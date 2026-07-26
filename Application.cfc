<cfcomponent>
	<cfset this.datasource = "alph">
	<cfset this.sessionManagement = true> 
	<cfset this.sessionTimeout = createTimeSpan(0,0,30,0) > <!--- Optional: Set session timeout to 30 minutes --->


	<cfset googleSiteKey = '6LfqdncqAAAAAHo_c2H8aXqHpTLCcGarAF3QFzJc'>
	<cfset googleSecretKey = '6LfqdncqAAAAAM3Psei9YEiKH8piiLmrYxMIOqeO'>	

</cfcomponent>