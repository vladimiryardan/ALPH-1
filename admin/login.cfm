<html>
<head>
    <title>Admin Login</title>
</head>
<body>
    <h2>Admin Login</h2>
    <cfif structKeyExists(url, 'msg')>
        <p style="color:red">#htmlEditFormat(url.msg)#</p>
    </cfif>
    <form method="post" action="login_action.cfm">
        <label>Username:<br><input type="text" name="username" required></label><br>
        <label>Password:<br><input type="password" name="password" required></label><br>
        <button type="submit">Login</button>
    </form>
</body>
</html>
