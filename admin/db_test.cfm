<!--- Diagnostics are available only in the local development server process. --->
<cfsetting showdebugoutput="false">
<cfinclude template="../inc_local_dev.cfm">
<cfif NOT request.isLocalDevelopment>
    <cfheader statuscode="404" statustext="Not Found">
    <cfabort>
</cfif>
<cfheader name="Cache-Control" value="no-store">
<cfheader name="X-Robots-Tag" value="noindex, nofollow">
<cftry>
    <cfquery name="qTest" datasource="#application.datasource#">
        SELECT 1 AS testval
    </cfquery>

    <html>
    <head><title>DB Test</title></head>
    <body>
        <h3>Datasource Test: OK</h3>
        <p>Returned value: #qTest.testval[1]#</p>
        <p><a href="index.cfm">Back to admin</a></p>
    </body>
    </html>

<cfcatch>
    <html>
    <head><title>DB Test - Failed</title></head>
    <body>
        <h3>Datasource Test: FAILED</h3>
        <p>Error: #cfcatch.message#</p>
        <p><a href="index.cfm">Back to admin</a></p>
    </body>
    </html>
</cfcatch>
</cftry>
