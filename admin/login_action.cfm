<cfif NOT structKeyExists(form, 'username')>
    <cfheader statusCode="302" name="Location" value="login.cfm?msg=Please+provide+credentials">
    <cfabort>
</cfif>

<cfset username = trim(form.username)>
<cfset password = trim(form.password)>

<cftry>
    <cfquery name="qUser" datasource="#application.datasource#">
        SELECT id, username
        FROM admin_users
        WHERE username = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">
          AND password = <cfqueryparam value="#password#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif qUser.recordCount gt 0>
        <cfset session.authenticated = true>
        <cfset session.username = qUser.username[1]>
        <cfheader statusCode="302" name="Location" value="index.cfm">
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
