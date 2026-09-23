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
    var secret = uCase(trim(arguments.requiredSecret));
    var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
    var bits = "";
    var hex = "";
    var position = 0;
    var value = 0;
    var binaryValue = "";
    var remainder = 0;

    if (!reFind("^[A-Z2-7]+={0,6}$", secret)) {
        throw(type="InvalidTotpSecret", message="Invalid Base32 authenticator secret.");
    }
    secret = reReplace(secret, "=+$", "");
    if (!listFind("0,2,4,5,7", len(secret) MOD 8)) {
        throw(type="InvalidTotpSecret", message="Invalid Base32 authenticator secret length.");
    }
    for (position = 1; position LTE len(secret); position++) {
        value = find(mid(secret, position, 1), alphabet) - 1;
        binaryValue = formatBaseN(value, 2);
        bits &= right("00000" & binaryValue, 5);
    }
    for (position = 1; position + 7 LTE len(bits); position += 8) {
        hex &= right("00" & formatBaseN(inputBaseN(mid(bits, position, 8), 2), 16), 2);
    }
    remainder = len(bits) MOD 8;
    if (remainder GT 0 AND inputBaseN(right(bits, remainder), 2) NEQ 0) {
        throw(type="InvalidTotpSecret", message="Invalid Base32 authenticator secret padding.");
    }
    return binaryDecode(hex, "hex");
}

function generateTotpCode(requiredSecret, currentCounter) {
    var secretBytes = decodeBase32(arguments.requiredSecret);
    var counterValue = arguments.currentCounter;
    var counterHex = "";
    var byteIndex = 0;
    var mac = createObject("java", "javax.crypto.Mac").getInstance("HmacSHA1");
    var key = createObject("java", "javax.crypto.spec.SecretKeySpec").init(secretBytes, "HmacSHA1");
    var digestHex = "";
    var offset = 0;
    var binaryCode = 0;

    // Eight-byte, big-endian counter; avoid signed Java byte/index conversions.
    for (byteIndex = 1; byteIndex LTE 8; byteIndex++) {
        counterHex = right("00" & formatBaseN(counterValue MOD 256, 16), 2) & counterHex;
        counterValue = int(counterValue / 256);
    }
    mac.init(key);
    digestHex = binaryEncode(mac.doFinal(binaryDecode(counterHex, "hex")), "hex");
    offset = inputBaseN(right(digestHex, 1), 16);
    binaryCode = bitAnd(inputBaseN(mid(digestHex, offset * 2 + 1, 2), 16), 127) * 16777216
        + inputBaseN(mid(digestHex, offset * 2 + 3, 6), 16);
    return right("000000" & (binaryCode MOD 1000000), 6);
}

function isValidTotpCode(requiredSecret, submittedCode) {
    var timeCounter = getCurrentTotpCounter();
    var loopIndex = 0;
    var code = trim(arguments.submittedCode);
    if (!reFind("^[0-9]{6}$", code)) {
        return false;
    }
    try {
        for (loopIndex = -2; loopIndex LTE 2; loopIndex++) {
            if (compare(code, generateTotpCode(arguments.requiredSecret, timeCounter + loopIndex)) EQ 0) {
                return true;
            }
        }
    } catch (any error) {
        // Invalid configuration must not authenticate or expose the secret.
        return false;
    }
    return false;
}
</cfscript>

<cfif form.step EQ "2fa">
    <cfif structKeyExists(session, 'twofa_pending') AND session.twofa_pending EQ true AND structKeyExists(session, 'twofa_secret')>
        <cfset submittedCode = trim(form.twofa_code)>
        <cfif reFind("^[0-9]{6}$", submittedCode)
            AND structKeyExists(session, 'twofa_expiresAt')
            AND isDate(session.twofa_expiresAt)
            AND now() LT session.twofa_expiresAt
            AND isValidTotpCode(session.twofa_secret, submittedCode)>
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

<!--- Explicit development opt-in plus a direct loopback request; fail closed by default.
      Set APP_ENV=development in the local server process only.
      Do not trust Host or forwarded headers to enable this bypass. --->
<cfset localDevEnvironment = createObject("java", "java.lang.System").getenv("APP_ENV")>
<cfset allowLocalDevLogin = false>
<cfif NOT isNull(localDevEnvironment)>
    <cfset allowLocalDevLogin = compareNoCase(trim(localDevEnvironment), "development") EQ 0
        AND listFindNoCase("127.0.0.1,::1,0:0:0:0:0:0:0:1,::ffff:127.0.0.1", trim(cgi.remote_addr)) GT 0>
</cfif>
<cfif allowLocalDevLogin AND username EQ "admin" AND password EQ "admin123">
    <cfset session.authenticated = true>
    <cfset session.username = "admin">
    <cfheader statusCode="302" name="Location" value="index.cfm">
    <cfabort>
</cfif>

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
        <!--- Never fall back to a shared development secret. --->
        <cfif NOT structKeyExists(application, 'adminTotpSecret') OR NOT len(trim(application.adminTotpSecret))>
            <cfset structDelete(session, 'twofa_pending')>
            <cfset structDelete(session, 'pending_username')>
            <cfset structDelete(session, 'twofa_secret')>
            <cfset structDelete(session, 'twofa_expiresAt')>
            <cflog file="atticladderph-auth" type="error" text="Admin login unavailable: ADMIN_TOTP_SECRET is not configured.">
            <cfheader statusCode="302" name="Location" value="login.cfm?msg=Login+temporarily+unavailable">
            <cfabort>
        </cfif>
        <cfset secretForTotp = trim(application.adminTotpSecret)>
        <cfif NOT isDefined('qUser.Username')>
            <cfset testUsername = "admin">
        <cfelse>
            <cfset testUsername = qUser.Username[1]>
        </cfif>
        <cfset session.twofa_pending = true>
        <cfset session.pending_username = testUsername>
        <cfset session.twofa_secret = secretForTotp>
        <cfset session.twofa_expiresAt = dateAdd("n", 10, now())>
        <cfheader statusCode="302" name="Location" value="login.cfm?msg=Enter+your+6-digit+authenticator+code">
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
