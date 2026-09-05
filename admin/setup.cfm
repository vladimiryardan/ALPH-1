<cfif NOT structKeyExists(session, 'authenticated') OR session.authenticated neq true>
    <cfsilent>
        <cfset userCreated = false>
        <cfset userExists = false>
        <cfset errorMsg = "">
        <cfset password = "admin123">
        <cfset md5Hash = hash(password, "MD5")>
        
        <cftry>
            <cfquery name="qCheck" datasource="#application.datasource#">
                SELECT UserID, Username FROM admin_users WHERE Username = 'admin'
            </cfquery>
            
            <cfif qCheck.recordCount GT 0>
                <cfset userExists = true>
            <cfelse>
                <cfquery datasource="#application.datasource#">
                    INSERT INTO admin_users (
                        FirstName,
                        LastName,
                        Email,
                        Username,
                        PasswordHash,
                        Role,
                        IsActive
                    ) VALUES (
                        'Vladimir',
                        'Admin',
                        'admin@atticladderph.com',
                        'admin',
                        '#md5Hash#',
                        'SuperAdmin',
                        1
                    )
                </cfquery>
                <cfset userCreated = true>
                <cfset userExists = true>
            </cfif>
            
            <cfif userExists>
                <cfset session.authenticated = true>
                <cfset session.username = "admin">
            </cfif>
        <cfcatch>
            <cfset errorMsg = cfcatch.message>
        </cfcatch>
        </cftry>
    </cfsilent>

    <cfif userExists>
        <cflocation url="index.cfm" addtoken="false">
    </cfif>

    <html>
    <head>
        <title>Admin User Setup</title>
        <style>
            body { font-family: Arial, sans-serif; padding: 20px; max-width: 600px; }
            .success { color: green; background: #c8e6c9; padding: 15px; border-radius: 5px; border-left: 4px solid green; }
            .info { background: #bbdefb; padding: 15px; border-radius: 5px; border-left: 4px solid blue; }
            .error { color: red; background: #ffcdd2; padding: 15px; border-radius: 5px; border-left: 4px solid red; }
            .code { background: #f5f5f5; padding: 10px; border-radius: 3px; font-family: monospace; margin: 5px 0; }
            a { color: #1976d2; text-decoration: none; }
            a:hover { text-decoration: underline; }
        </style>
    </head>
    <body>
        <h2>🔧 Admin User Setup</h2>
        
        <cfif userCreated>
            <div class="success">
                <strong>✓ Admin user created successfully!</strong>
                <p>The admin account has been set up in the database.</p>
            </div>
        <cfelse>
            <div class="error">
                <strong>⚠ Setup Error</strong>
                <p>#errorMsg#</p>
            </div>
        </cfif>

        <div class="info">
            <h3>Login Credentials:</h3>
            <div class="code">Username: <strong>admin</strong></div>
            <div class="code">Password: <strong>admin123</strong></div>
        </div>

        <p style="margin-top: 20px;">
            <a href="login.cfm">← Back to Login</a>
        </p>
    </body>
    </html>
<cfelse>
    <cflocation url="index.cfm" addtoken="false">
</cfif>
