<cfcomponent>
	<cfset this.datasource = "atticladderph">
	<cfset this.sessionManagement = true>
	<cfset this.sessionTimeout = createTimeSpan(0,0,30,0)>
	<!--- http://127.0.0.1:60082/lucee/admin/server.cfm?action=server.error --->

	<cfset this.showDebugOutput = false>
	<!--- recatpcha: https://www.google.com/recaptcha/admin/site/762118480 atticladderph@gmail.com--->



	<cffunction name="onApplicationStart" access="public" returntype="boolean">
        <!--- Keep credentials in the server process environment, not source control. --->
		<cfset application.datasource = this.datasource>
        <cfset application.adminTotpSecret = trim(readEnvironmentVariable("ADMIN_TOTP_SECRET", ""))>
        <cfset application.smtp = {
            server = readEnvironmentVariable("SMTP_HOST", ""),
            port = val(readEnvironmentVariable("SMTP_PORT", "465")),
            username = readEnvironmentVariable("SMTP_USERNAME", ""),
            password = readEnvironmentVariable("SMTP_PASSWORD", ""),
            usetls = compareNoCase(readEnvironmentVariable("SMTP_TLS", "false"), "false") EQ 0,
            useSSL = compareNoCase(readEnvironmentVariable("SMTP_SSL", "true"), "true") EQ 0,
            fromEmail = readEnvironmentVariable("SMTP_FROM", "vlad@atticladderph.com"),
            toEmail = readEnvironmentVariable("SMTP_TO", "sales@atticladderph.com"),
            replyToEmail = readEnvironmentVariable("SMTP_REPLY_TO", "sales@atticladderph.com")
        }>
        <cfset application.smtp.mailAttributes = {
            server = application.smtp.server,
            port = application.smtp.port,
            username = application.smtp.username,
            password = application.smtp.password,
            usetls = application.smtp.usetls,
            useSSL = application.smtp.useSSL
        }>
        <cfset application.contactSettings = {
            senderEmail = application.smtp.fromEmail
        }>
        <cfset application.recaptcha = {
            siteKey = readEnvironmentVariable("RECAPTCHA_SITE_KEY", ""),
            secretKey = readEnvironmentVariable("RECAPTCHA_SECRET_KEY", "")
        }>

        <cfset smtpServer = structNew()>

        <cfset smtpServer.host = server.system.environment.SMTP_HOST>
        <cfset smtpServer.port = val(server.system.environment.SMTP_PORT)>
        <cfset smtpServer.username = server.system.environment.SMTP_USERNAME>
        <cfset smtpServer.password = server.system.environment.SMTP_PASSWORD>
        <cfset smtpServer.ssl = server.system.environment.SMTP_SSL>
        <cfset smtpServer.tls = server.system.environment.SMTP_TLS>

        <cfset this.mailservers = arrayNew(1)>
        <cfset arrayAppend(this.mailservers, smtpServer)>

		<cfreturn true>
	</cffunction>

    <cffunction name="readEnvironmentVariable" access="private" returntype="string" output="false">
        <cfargument name="name" type="string" required="true">
        <cfargument name="defaultValue" type="string" required="false" default="">
        <cfset var value = createObject("java", "java.lang.System").getenv(arguments.name)>
        <cfif isNull(value) OR NOT len(value)>
            <cfreturn arguments.defaultValue>
        </cfif>
        <cfreturn value>
    </cffunction>


    <cffunction name="onMissingTemplate" access="public" returntype="boolean" output="true">
        <cfargument name="targetPage" type="string" required="true">
        <!--- Use a fixed template; never echo or include the requested URL. --->
        <cfinclude template="404.cfm">
        <cfreturn true>
    </cffunction>

	<cffunction name="onError" access="public" returntype="void" output="true">
        <cfargument name="exception" type="any" required="true">
        <cfargument name="eventName" type="string" required="true">
        <cfset var errorReference = createUUID()>
        <cfset var errorDetails = { reference = errorReference, event = arguments.eventName }>
        <cfinclude template="inc_local_dev.cfm">
        <cfsetting showdebugoutput="false">
        <!--- Some Lucee configurations dispatch missing requests directly here. --->
        <cfif structKeyExists(arguments.exception, "MissingFileName")
            AND compareNoCase(arguments.exception.MissingFileName, cgi.script_name) EQ 0>
            <cfinclude template="404.cfm">
            <cfreturn>
        </cfif>
        <!--- Log diagnostic fields privately, never entire request/session scopes. --->
        <cftry>
            <cfif structKeyExists(arguments.exception, "type")>
                <cfset errorDetails.type = arguments.exception.type>
            </cfif>
            <cfif structKeyExists(arguments.exception, "message")>
                <cfset errorDetails.message = arguments.exception.message>
            </cfif>
            <cfif structKeyExists(arguments.exception, "detail")>
                <cfset errorDetails.detail = arguments.exception.detail>
            </cfif>
            <cfif structKeyExists(arguments.exception, "stackTrace")>
                <cfset errorDetails.stackTrace = arguments.exception.stackTrace>
            </cfif>
            <cflog file="atticladderph-errors" type="error" text="#serializeJSON(errorDetails)#">
            <cfcatch type="any">
                <!--- A logging failure must not reveal the original exception. --->
            </cfcatch>
        </cftry>
        <cfheader statuscode="500" statustext="Internal Server Error">
        <cfheader name="Cache-Control" value="no-store">
        <cfheader name="X-Robots-Tag" value="noindex, nofollow">
        <cfcontent type="text/html; charset=utf-8" reset="true">
        <cfif request.isLocalDevelopment>
            <h1>Application Error (Local Development)</h1>
            <p>Reference: <cfoutput>#encodeForHTML(errorReference)#</cfoutput></p>
            <cfdump var="#arguments.exception#" label="Exception Details" expand="true">
            <cfdump var="#arguments.eventName#" label="Event Name">
            <cfdump var="#CGI#" label="CGI Scope" expand="false">
            <cfdump var="#URL#" label="URL Scope" expand="false">
            <cfdump var="#FORM#" label="FORM Scope" expand="false">
            <cfreturn>
        </cfif>
        <!doctype html>
        <html lang="en">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Something Went Wrong | Attic Ladder PH</title>
        </head>
        <body>
            <main>
                <h1>Something went wrong</h1>
                <p>We couldn't complete your request. Please try again later.</p>
                <p><a href="/">Return to Home</a> or <a href="tel:+639778497190">call 0977 849 7190</a> for help.</p>
                <p>Reference: <cfoutput>#encodeForHTML(errorReference)#</cfoutput></p>
            </main>
        </body>
        </html>
    </cffunction>


    <cffunction name="onRequestStart" returntype="boolean" output="false">
        <cfargument name="targetPage" type="string" required="true">
        <cfsetting showdebugoutput="false">

        <cfif structKeyExists(url, "restartApp") AND url.restartApp EQ "1">
            <!--- Recheck changed CFML templates as well as application variables. --->
            <cfset inspectTemplates()>
            <cfset applicationStop()>
            <cflocation url="/" addtoken="false">
        </cfif>

        <cfreturn true>
    </cffunction>

</cfcomponent>
