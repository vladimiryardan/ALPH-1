<!--- Shared request-level guard for local development features.
      Re-evaluate on every include; never trust Host or forwarded headers.
      APP_ENV must be set only in the local server process. --->
<cfsilent>
    <cfset request.isLocalDevelopment = false>
    <cfif structKeyExists(cgi, "remote_addr")>
        <cfset request.isLocalDevelopment = compareNoCase(
            trim(createObject("java", "java.lang.System").getenv().getOrDefault("APP_ENV", "")),
            "development"
        ) EQ 0 AND listFindNoCase(
            "127.0.0.1,::1,0:0:0:0:0:0:0:1,::ffff:127.0.0.1",
            trim(cgi.remote_addr)
        ) GT 0>
    </cfif>
</cfsilent>
