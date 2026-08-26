<cfcomponent>
	<cfset this.datasource = "alph">
	<cfset this.sessionManagement = true>
	<cfset this.sessionTimeout = createTimeSpan(0,0,30,0)>
	<cfset this.adminTotpSecret = "" >
	<!--- http://127.0.0.1:60082/lucee/admin/server.cfm?action=server.error --->

	<cfset this.showDebugOutput = true>
	<!--- recatpcha: https://www.google.com/recaptcha/admin/site/762118480 atticladderph@gmail.com--->



	<cffunction name="onApplicationStart" access="public" returntype="boolean">
        <!--- Keep credentials in the server process environment, not source control. --->
		<cfset application.datasource = this.datasource>
		<cfset application.adminTotpSecret = this.adminTotpSecret>
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


	<cffunction name="onError" access="public" returntype="void" output="true">
        <cfargument name="exception" type="any" required="true">
        <cfargument name="eventName" type="string" required="true">
        <h1>Application Error</h1>
        <cfdump var="#arguments.exception#" label="Exception Details" expand="true">
        <cfdump var="#arguments.eventName#" label="Event Name">
        <cfdump var="#CGI#" label="CGI Scope" expand="false">
        <cfdump var="#URL#" label="URL Scope" expand="false">
        <cfdump var="#FORM#" label="FORM Scope" expand="false">
        <cfabort>
    </cffunction>


    <cffunction name="onRequestStart" returntype="boolean" output="false">
        <cfargument name="targetPage" type="string" required="true">

        <cfif structKeyExists(url, "restartApp") AND url.restartApp EQ "1">
            <cfset applicationStop()>
            <cflocation url="/" addtoken="false">
        </cfif>

        <cfreturn true>
    </cffunction>

</cfcomponent>
