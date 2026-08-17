<cfif structKeyExists(session, 'authenticated')>
    <cfset structDelete(session, 'authenticated')>
    <cfset structDelete(session, 'username')>
</cfif>

<cfset structDelete(session, 'twofa_pending')>
<cfset structDelete(session, 'pending_username')>
<cfset structDelete(session, 'twofa_secret')>
<cfset structDelete(session, 'twofa_expiresAt')>

<cfheader statusCode="302" name="Location" value="login.cfm?msg=Logged+out">
<cfabort>
