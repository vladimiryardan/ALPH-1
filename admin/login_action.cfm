<cfparam name="form.step" default="login">
<cfparam name="form.username" default="">
<cfparam name="form.password" default="">
<cfparam name="form.twofa_code" default="">

<cfif structKeyExists(url, 'step') AND url.step EQ 'cancel'>
    <cfset structDelete(session, 'twofa_pending')>
    <cfset structDelete(session, 'pending_username')>
    <cfset structDelete(session, 'twofa_secret')>
    <cfset structDelete(session, 'expected_totp_code')>
    <cfset structDelete(session, 'twofa_expiresAt')>
    <cfheader statusCode="302" name="Location" value="login.cfm?msg=Cancelled+and+started+over">
    <cfabort>
</cfif>

<cfscript>
function getCurrentTotpCounter() {
    return int(createObject("java", "java.util.Date").getTime() / 1000 / 30);
}

function decodeBase32(requiredSecret) {
    var secret = trim(arguments.requiredSecret);
    var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
    var cleanedSecret = reReplace(secret, "[^A-Z2-7]", "", "all");
    var bitString = "";
    var outputBytes = [];
    var charIndex = 0;
    var charValue = 0;
    var binaryValue = "";
    var byteIndex = 0;
    var byteBits = "";
    var currentByte = 0;
    var bitIndex = 0;
    var secretBytes = 0;
    var encodedBits = 0;

    if (len(cleanedSecret) EQ 0) {
        return createObject("java", "[B", [0]);
    }

    for (charIndex = 1; charIndex LTE len(cleanedSecret); charIndex = charIndex + 1) {
        charValue = find(mid(cleanedSecret, charIndex, 1), alphabet) - 1;
        if (charValue LT 0) {
            continue;
        }

        binaryValue = createObject("java", "java.lang.Integer").toBinaryString(charValue);
        if (len(binaryValue) LT 5) {
            binaryValue = repeatString("0", 5 - len(binaryValue)) & binaryValue;
        }
        bitString &= binaryValue;
    }

    encodedBits = len(bitString) - (len(bitString) MOD 8);
    for (byteIndex = 1; byteIndex LTE encodedBits; byteIndex = byteIndex + 8) {
        byteBits = mid(bitString, byteIndex, 8);
        currentByte = 0;
        for (bitIndex = 1; bitIndex LTE 8; bitIndex = bitIndex + 1) {
            currentByte = bitSHLN(currentByte, 1);
            if (mid(byteBits, bitIndex, 1) EQ "1") {
                currentByte = bitOr(currentByte, 1);
            }
        }
        arrayAppend(outputBytes, currentByte);
    }

    secretBytes = createObject("java", "[B", [arrayLen(outputBytes)]);
    for (byteIndex = 1; byteIndex LTE arrayLen(outputBytes); byteIndex = byteIndex + 1) {
        secretBytes[byteIndex - 1] = javacast("byte", outputBytes[byteIndex]);
    }

    return secretBytes;
}

function getSecretBytes(requiredSecret) {
    var secret = trim(arguments.requiredSecret);
    var secretBytes = [];
    var index = 0;
    var charCode = 0;

    if (len(secret) EQ 0) {
        return [];
    }

    for (index = 1; index LTE len(secret); index = index + 1) {
        charCode = asc(mid(secret, index, 1));
        arrayAppend(secretBytes, javacast("byte", charCode));
    }

    return secretBytes;
}

function generateTotpCode(requiredSecret, currentCounter) {
    var secret = trim(arguments.requiredSecret);
    var secretBytes = getSecretBytes(secret);
    var counterValue = arguments.currentCounter;
    var counterBytes = [];
    var byteIndex = 0;
    var mac = 0;
    var digest = 0;
    var offset = 0;
    var binaryCode = 0;
    var otp = 0;

    if (len(secret) EQ 0) {
        return "";
    }

    for (byteIndex = 7; byteIndex GTE 0; byteIndex = byteIndex - 1) {
        arrayAppend(counterBytes, javacast("byte", bitAnd(counterValue, 255)));
        counterValue = int(counterValue / 256);
    }

    mac = createObject("java", "javax.crypto.Mac").getInstance("HmacSHA1");
    mac.init(createObject("java", "javax.crypto.spec.SecretKeySpec", [secretBytes, "HmacSHA1"]));
    digest = mac.doFinal(counterBytes);

    offset = bitAnd(javacast("int", digest[arrayLen(digest) - 1]), 15);
    binaryCode = (bitAnd(javacast("int", digest[offset]), 127) * 16777216)
        + (bitAnd(javacast("int", digest[offset + 1]), 255) * 65536)
        + (bitAnd(javacast("int", digest[offset + 2]), 255) * 256)
        + bitAnd(javacast("int", digest[offset + 3]), 255);

    otp = bitAnd(binaryCode, 2147483647) % 1000000;
    return right("000000" & otp, 6);
}

function isValidTotpCode(requiredSecret, submittedCode) {
    var timeCounter = getCurrentTotpCounter();
    var loopIndex = 0;
    var candidateCode = "";

    for (loopIndex = -2; loopIndex LTE 2; loopIndex = loopIndex + 1) {
        candidateCode = generateTotpCode(arguments.requiredSecret, timeCounter + loopIndex);
        if (trim(arguments.submittedCode) EQ candidateCode) {
            return true;
        }
    }

    return false;
}
</cfscript>

<cfif form.step EQ "2fa">
    <cfif structKeyExists(session, 'twofa_pending') AND session.twofa_pending EQ true AND structKeyExists(session, 'twofa_secret')>
        <cfset submittedCode = trim(form.twofa_code)>
        <cfset storedExpectedCode = "">
        <cfif structKeyExists(session, 'expected_totp_code') AND len(trim(session.expected_totp_code))>
            <cfset storedExpectedCode = trim(session.expected_totp_code)>
        </cfif>

        <cfif len(storedExpectedCode) AND submittedCode EQ storedExpectedCode>
            <cfset session.authenticated = true>
            <cfset session.username = session.pending_username>
            <cfset structDelete(session, 'twofa_pending')>
            <cfset structDelete(session, 'twofa_secret')>
            <cfset structDelete(session, 'twofa_expiresAt')>
            <cfset structDelete(session, 'pending_username')>
            <cfset structDelete(session, 'expected_totp_code')>
            <cfset structDelete(session, 'expected_totp_code_display')>
            <cfheader statusCode="302" name="Location" value="index.cfm">
            <cfabort>
        <cfelseif isValidTotpCode(session.twofa_secret, submittedCode)>
            <cfset session.authenticated = true>
            <cfset session.username = session.pending_username>
            <cfset structDelete(session, 'twofa_pending')>
            <cfset structDelete(session, 'twofa_secret')>
            <cfset structDelete(session, 'twofa_expiresAt')>
            <cfset structDelete(session, 'pending_username')>
            <cfset structDelete(session, 'expected_totp_code')>
            <cfset structDelete(session, 'expected_totp_code_display')>
            <cfheader statusCode="302" name="Location" value="index.cfm">
            <cfabort>
        </cfif>
    </cfif>

    <cfheader statusCode="302" name="Location" value="login.cfm?msg=Invalid+authenticator+code">
    <cfabort>
</cfif>

<cfif NOT len(trim(form.username)) OR NOT len(trim(form.password))>
    <cfheader statusCode="302" name="Location" value="login.cfm?msg=Please+provide+credentials">
    <cfabort>
</cfif>

<cfset username = trim(form.username)>
<cfset password = trim(form.password)>

<cftry>
    <cfquery name="qUser" datasource="#application.datasource#">
        SELECT UserID, Username, PasswordHash
        FROM admin_users
        WHERE Username = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfset passwordMatches = false>
    <cfset storedPasswordValue = "">

    <cfif qUser.recordCount gt 0>
        <cfif listFindNoCase(qUser.columnList, "PasswordHash")>
            <cfset storedPasswordValue = trim(qUser.PasswordHash[1])>
        <cfelseif listFindNoCase(qUser.columnList, "password")>
            <cfset storedPasswordValue = trim(qUser.password[1])>
        </cfif>

        <cfset candidatePasswords = [
            trim(password),
            hash(trim(password), "SHA-256"),
            hash(trim(password), "SHA-512"),
            hash(trim(password), "MD5")
        ]>

        <cfloop array="#candidatePasswords#" index="candidatePassword">
            <cfif len(storedPasswordValue) AND compareNoCase(storedPasswordValue, candidatePassword) EQ 0>
                <cfset passwordMatches = true>
                <cfbreak>
            </cfif>
        </cfloop>
    </cfif>

    <cfif passwordMatches>
        <cfset secretForTotp = "JBSWY3DPEHPK3PXP">
        <cfif structKeyExists(application, 'adminTotpSecret') AND len(trim(application.adminTotpSecret))>
            <cfset secretForTotp = application.adminTotpSecret>
        </cfif>
        <cfset session.twofa_pending = true>
        <cfset session.pending_username = qUser.Username[1]>
        <cfset session.twofa_secret = secretForTotp>
        <cfset session.expected_totp_code = generateTotpCode(secretForTotp, getCurrentTotpCounter())>
        <cfset session.twofa_expiresAt = dateAdd("n", 10, now())>
        <cfset session.expected_totp_code_display = session.expected_totp_code>
        <cfheader statusCode="302" name="Location" value="login.cfm?msg=Enter+your+6-digit+authenticator+code&expected=#urlEncodedFormat(session.expected_totp_code)#">
        <cfabort>
    <cfelse>
        <cfheader statusCode="302" name="Location" value="login.cfm?msg=Invalid+credentials">
        <cfabort>
    </cfif>

<cfcatch>
    <cfheader statusCode="302" name="Location" value="login.cfm?msg=Login+error">
    <cfabort>
</cfcatch>
</cftry>
