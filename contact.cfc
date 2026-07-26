<cfcomponent >
<cfsilent>
	

  <cffunction name="fnContactForm" access="remote" returntype="Any" returnformat="plain" >
    <cfargument name="data" type="string" required="false" >


<!---	<cfset local.name = arguments.name>
	<cfset local.email = arguments.email>
	<cfset local.message = arguments.message>--->
	
	<cfif arguments.canswer NEQ session.captchaText>
		<cfreturn "Message Failed">
	</cfif>


	<cfquery>
		INSERT INTO ContactForm(
			FullName,
			Email,
			SUBJECT,
			Message
		)
		VALUES
			(
		'#arguments.name#',
		'#arguments.email#',
		'Contact Form',
		'#arguments.message#');
				
	</cfquery>
	
    <cftry>  
    <cfcatch>
      <cfoutput>
        #cfcatch.Detail#<br />
        #cfcatch.Message#<br />
        #cfcatch.tagcontext[1].line#:#cfcatch.tagcontext[1].template#
      </cfoutput>
    </cfcatch>
    </cftry>
   
<cfset cleanResponse = encodeForHTML(trim("Success"))>
<cfreturn cleanResponse>


    
  </cffunction>
  
</cfsilent>	  
</cfcomponent>