<!--- Local diagnostic page; never expose verification tokens or secret keys. --->
<cfsetting showdebugoutput="false">
<cfif NOT listFindNoCase("127.0.0.1,::1,0:0:0:0:0:0:0:1", cgi.remote_addr)>
    <cfheader statuscode="404" statustext="Not Found">
    <cfabort>
</cfif>
<cfheader name="Cache-Control" value="no-store">
<cfheader name="X-Robots-Tag" value="noindex, nofollow">
<cfset captchaConfigured = structKeyExists(application, "recaptcha") AND isStruct(application.recaptcha)
    AND structKeyExists(application.recaptcha, "siteKey") AND len(trim(application.recaptcha.siteKey))
    AND structKeyExists(application.recaptcha, "secretKey") AND len(trim(application.recaptcha.secretKey))>
<cfset verificationPassed = false>
<cfset statusMessage = "">
<cfif cgi.request_method EQ "POST">
    <cfif NOT captchaConfigured>
        <cfset statusMessage = "Set both reCAPTCHA environment variables and restart the local server before testing.">
    <cfelseif NOT structKeyExists(form, "g-recaptcha-response") OR NOT isSimpleValue(form["g-recaptcha-response"]) OR NOT len(trim(form["g-recaptcha-response"]))>
        <cfset statusMessage = "Please complete the reCAPTCHA checkbox before verifying.">
    <cfelse>
        <cftry>
            <cfhttp url="https://www.google.com/recaptcha/api/siteverify" method="post" result="captchaHttp" timeout="15" redirect="false">
                <cfhttpparam type="formfield" name="secret" value="#application.recaptcha.secretKey#">
                <cfhttpparam type="formfield" name="response" value="#trim(form['g-recaptcha-response'])#">
            </cfhttp>
            <cfif val(captchaHttp.statusCode) NEQ 200 OR NOT isJSON(captchaHttp.fileContent)>
                <cfthrow message="Verification service unavailable">
            </cfif>
            <cfset captchaResult = deserializeJSON(captchaHttp.fileContent)>
            <cfif isStruct(captchaResult) AND structKeyExists(captchaResult, "success") AND isBoolean(captchaResult.success) AND captchaResult.success>
                <cfif structKeyExists(captchaResult, "hostname") AND listFindNoCase("localhost,127.0.0.1,::1,[::1]", captchaResult.hostname)>
                    <cfset verificationPassed = true>
                    <cfset statusMessage = "Verification successful. Google accepted your reCAPTCHA response for localhost.">
                <cfelse>
                    <cfset statusMessage = "Verification rejected: the response was not issued for localhost.">
                </cfif>
            <cfelse>
                <cfset statusMessage = "Verification failed. Complete a fresh challenge and try again. If this continues, check that your site key and secret key belong to the same reCAPTCHA v2 registration.">
            </cfif>
            <cfcatch type="any">
                <cfset statusMessage = "Could not verify with Google. Check the server's internet connection and try again.">
            </cfcatch>
        </cftry>
    </cfif>
</cfif>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="robots" content="noindex, nofollow">
    <title>Local reCAPTCHA verification | Attic Ladder PH</title>
    <link href="css/styles.css" rel="stylesheet">
    <style>
        body { min-height: 100vh; background: #f3f6fa; }
        main { max-width: 600px; margin: 8vh auto; padding: 24px; }
        .verification-card { background: white; padding: clamp(16px, 4vw, 36px); border-radius: 16px; box-shadow: 0 12px 40px #14264012; }
        .eyebrow { color: #536477; font-size: .8rem; font-weight: 700; letter-spacing: .12em; }
    </style>
</head>
<body>
<main>
    <div class="verification-card">
        <p class="eyebrow">ATTIC LADDER PH / LOCALHOST</p>
        <h1 class="h3 mb-3">reCAPTCHA verification</h1>
        <p class="text-muted">Complete the checkbox, then verify your response with Google.</p>
        <cfif len(statusMessage)>
            <cfoutput><div role="status" class="alert <cfif verificationPassed>alert-success<cfelse>alert-danger</cfif>">#encodeForHTML(statusMessage)#</div></cfoutput>
        </cfif>
        <cfif captchaConfigured>
            <form method="post" action="recaptcha-test.cfm" id="verification-form">
                <cfoutput><div class="g-recaptcha mb-4" data-sitekey="#encodeForHTMLAttribute(application.recaptcha.siteKey)#" data-size="compact" data-callback="captchaReady" data-expired-callback="captchaExpired" data-error-callback="captchaError"></div></cfoutput>
                <button class="btn btn-primary w-100" type="submit" id="verify-button" disabled>Verify response</button>
                <p id="captcha-status" class="small text-muted mt-3 mb-0" role="status">Loading reCAPTCHA…</p>
            </form>
            <script>
                const button = document.getElementById('verify-button');
                const status = document.getElementById('captcha-status');
                function captchaReady() { button.disabled = false; status.textContent = 'Ready to verify.'; }
                function captchaExpired() { button.disabled = true; status.textContent = 'Response expired. Please complete the checkbox again.'; }
                function captchaError() { button.disabled = true; status.textContent = 'reCAPTCHA could not load. Check your connection, browser restrictions, and site key settings.'; }
                function captchaLoaded() { status.textContent = 'Complete the checkbox to continue.'; }
                document.getElementById('verification-form').addEventListener('submit', function () {
                    button.disabled = true;
                    button.textContent = 'Verifying…';
                    status.textContent = 'Checking your response with Google.';
                });
            </script>
            <script src="https://www.google.com/recaptcha/api.js?onload=captchaLoaded" async defer onerror="captchaError()"></script>
        <cfelse>
            <div class="alert alert-warning">reCAPTCHA keys are not configured.</div>
            <ol class="ps-3">
                <li>Create a reCAPTCHA v2 <strong>I'm not a robot Checkbox</strong> key pair with <code>localhost</code> in its allowed domains.</li>
                <li>Set <code>RECAPTCHA_SITE_KEY</code> and <code>RECAPTCHA_SECRET_KEY</code> in the local server environment.</li>
                <li>Restart the local server and reload this page.</li>
            </ol>
        </cfif>
        <hr class="my-4">
        <p class="small text-muted mb-0">Use localhost with the port assigned to this Lucee server. This page only tests verification; it does not submit an enquiry.</p>
    </div>
</main>
</body>
</html>
