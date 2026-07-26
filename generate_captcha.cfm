<cfset session.captchaText = randRange(1000, 9999)>

<!--- <cfset session.captchaText = left(createUUID(), 6)> --->

<cfset imagewritetobrowser(imagecaptcha( "#session.captchaText#", 100, 300, "low"))>