<cfif NOT structKeyExists(session, 'authenticated') OR session.authenticated neq true>
    <cfheader statusCode="302" name="Location" value="login.cfm">
    <cfabort>
</cfif>

<html>
<head>
    <title>Admin Dashboard</title>
</head>
<body>
    <h2>Welcome, #htmlEditFormat(session.username)#</h2>
    <ul>
        <li><a href="db_test.cfm">Datasource connection test</a></li>
        <li><a href="logout.cfm">Logout</a></li>
    </ul>
</body>
</html>
