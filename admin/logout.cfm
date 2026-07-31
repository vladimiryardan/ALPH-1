<cfif structKeyExists(session, 'authenticated')>
    <cfset structDelete(session, 'authenticated')>
    <cfset structDelete(session, 'username')>
</cfif>
<cfheader statusCode="302" name="Location" value="login.cfm?msg=Logged+out">
<cfabort>
