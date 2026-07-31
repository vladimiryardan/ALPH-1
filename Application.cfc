<cfcomponent>
	<cfset this.datasource = "alph">
	<cfset this.sessionManagement = true> 
	<cfset this.sessionTimeout = createTimeSpan(0,0,30,0) > <!--- Optional: Set session timeout to 30 minutes --->
	<!--- http://127.0.0.1:60082/lucee/admin/server.cfm?action=server.error --->

	<cfset this.showDebugOutput = true>
	<!--- recatpcha: https://www.google.com/recaptcha/admin/site/762118480 atticladderph@gmail.com--->
	


	<cffunction name="onApplicationStart" access="public" returntype="boolean">
		<!--- copy the configured datasource into application scope for pages --->
		<cfset application.datasource = this.datasource>
		<cfreturn true>
	</cffunction>


	<cffunction
    name="onError"
    access="public"
    returntype="void"
    output="true">

    <cfargument
        name="exception"
        type="any"
        required="true">

    <cfargument
        name="eventName"
        type="string"
        required="true">

    <h1>Application Error</h1>

    <cfdump
        var="#arguments.exception#"
        label="Exception Details"
        expand="true">

    <cfdump
        var="#arguments.eventName#"
        label="Event Name">

    <cfdump
        var="#CGI#"
        label="CGI Scope"
        expand="false">

    <cfdump
        var="#URL#"
        label="URL Scope"
        expand="false">

    <cfdump
        var="#FORM#"
        label="FORM Scope"
        expand="false">

    <cfabort>
</cffunction>



</cfcomponent>
