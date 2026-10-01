<html>
<head>
    <title>Admin Login</title>
</head>
<body>
    <h2>Admin Login</h2>
    <cfset loginMessage = "">
    <cfset expectedCode = "">
    <cfif structKeyExists(url, 'msg') AND len(trim(url.msg))>
        <cfset loginMessage = urlDecode(url.msg)>
    </cfif>
    <cfif structKeyExists(url, 'expected') AND len(trim(url.expected))>
        <cfset expectedCode = urlDecode(url.expected)>
    </cfif>
    <cfif len(trim(loginMessage))>
        <cfoutput>
            <p style="color:red">#htmlEditFormat(loginMessage)#</p>
        </cfoutput>
    </cfif>

    <cfif structKeyExists(session, 'twofa_pending') AND session.twofa_pending EQ true>
        <p>Open Google Authenticator and enter the 6-digit code below.</p>
        <form method="post" action="login_action.cfm">
            <input type="hidden" name="step" value="2fa">
            <label>6-Digit Authenticator Code:<br><input type="text" name="twofa_code" required maxlength="6" pattern="[0-9]{6}"></label><br>
            <button type="submit">Verify Code</button>
        </form>
        <p>
            <a href="login_action.cfm?step=cancel">Cancel and start over</a>
        </p>
    <cfelse>
        <form method="post" action="login_action.cfm">
            <input type="hidden" name="step" value="login">
            <label>Username:<br><input type="text" name="username" required></label><br>
            <label>Password:<br><input type="password" name="password" required></label><br>
            <button type="submit">Login</button>
        </form>
    </cfif>
</body>
</html>
