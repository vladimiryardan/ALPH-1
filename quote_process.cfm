<cfsetting requesttimeout="120">

<!---
    Attic Ladder PH quote request handler
    IMPORTANT: Update the settings below before publishing.
--->
<cfset settings = {
    businessName = "Attic Ladder PH",
    quoteRecipient = application.smtp.toEmail,
    fromEmail = application.smtp.fromEmail,
    replyToEmail = application.smtp.replyToEmail,
    thankYouPage = "quote-thank-you.cfm",
    formPage = "quoterequest.cfm",
    uploadFolder = expandPath("./uploads/quote-requests"),
    uploadUrl = application.siteUrl & "/uploads/quote-requests",
    maxFiles = 5,
    maxFileSizeBytes = 5 * 1024 * 1024,
    allowedExtensions = "jpg,jpeg,png,webp,pdf"
}>

<!--- Only accept POST submissions. --->
<cfif CGI.REQUEST_METHOD NEQ "POST">
    <cflocation url="#settings.formPage#" addtoken="false">
</cfif>

<!--- Form defaults. --->
<cfparam name="form.fullname" default="">
<cfparam name="form.mobile" default="">
<cfparam name="form.email" default="">
<cfparam name="form.city" default="">
<cfparam name="form.service" default="">
<cfparam name="form.property" default="">
<cfparam name="form.height" default="">
<cfparam name="form.opening" default="">
<cfparam name="form.contact_method" default="">
<cfparam name="form.notes" default="">
<cfparam name="form.website" default="">
<cfif NOT structKeyExists(form, "g-recaptcha-response")>
    <cfset form["g-recaptcha-response"] = "">
</cfif>

<!--- Honeypot: bots often fill hidden fields. --->
<cfif len(trim(form.website))>
    <cflocation url="#settings.thankYouPage#" addtoken="false">
</cfif>

<!---
    Google reCAPTCHA v2 server-side verification
--->
<cfset recaptchaToken = trim(form["g-recaptcha-response"])>

<cfif NOT len(recaptchaToken)>
    <cfheader statuscode="400" statustext="Bad Request">
    <!doctype html>
    <html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Please check your form</title>
        <link href="css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <main class="container py-5">
            <div class="card border-0 shadow-sm mx-auto" style="max-width:700px;">
                <div class="card-body p-4 p-md-5">
                    <h1 class="h3 mb-3">Please check your information</h1>
                    <p class="text-danger mb-4">Please complete the reCAPTCHA verification.</p>
                    <a class="btn btn-dark" href="<cfoutput>#encodeForHTMLAttribute(settings.formPage)#</cfoutput>" onclick="history.back(); return false;">Return to the form</a>
                </div>
            </div>
        </main>
    </body>
    </html>
    <cfabort>
</cfif>

<cfset recaptchaPayload = {
    "event" = {
        "token" = recaptchaToken,
        "siteKey" = application.recaptcha.siteKey,
        "expectedAction" = "QUOTE"
    }
}>

<cfhttp
    url="https://recaptchaenterprise.googleapis.com/v1/projects/quoterequest-alp-1785394043212/assessments?key=#application.recaptcha.enterpriseApiKey#"
    method="post"
    result="recaptchaHttpResult"
    throwonerror="false">

    <cfhttpparam
        type="header"
        name="Content-Type"
        value="application/json">

    <cfhttpparam
        type="body"
        value="#serializeJSON(recaptchaPayload)#">

</cfhttp>

<cfset recaptchaResult = {}>

<cftry>
    <cfset recaptchaResult = deserializeJSON(recaptchaHttpResult.fileContent)>

    <cfcatch type="any">
        <cfset recaptchaResult = {}>
    </cfcatch>
</cftry>

<cfif NOT (
    structKeyExists(recaptchaResult, "tokenProperties")
    AND structKeyExists(recaptchaResult.tokenProperties, "valid")
    AND recaptchaResult.tokenProperties.valid
    AND structKeyExists(recaptchaResult.tokenProperties, "action")
    AND recaptchaResult.tokenProperties.action EQ "QUOTE"
)>
    <cflog file="attic-ladder-quotes" type="Information" text="Quote reCAPTCHA verification failed. IP: #CGI.REMOTE_ADDR#">
    <cfheader statuscode="400" statustext="Bad Request">
    <!doctype html>
    <html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Please check your form</title>
        <link href="css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <main class="container py-5">
            <div class="card border-0 shadow-sm mx-auto" style="max-width:700px;">
                <div class="card-body p-4 p-md-5">
                    <h1 class="h3 mb-3">Please check your information</h1>
                    <p class="text-danger mb-4">The reCAPTCHA verification failed. Please try again.</p>
                    <a class="btn btn-dark" href="<cfoutput>#encodeForHTMLAttribute(settings.formPage)#</cfoutput>" onclick="history.back(); return false;">Return to the form</a>
                </div>
            </div>
        </main>
    </body>
    </html>
    <cfabort>
</cfif>

<!--- Normalize submitted values. --->
<cfset quote = {
    fullname = trim(form.fullname),
    mobile = trim(form.mobile),
    email = trim(form.email),
    city = trim(form.city),
    service = trim(form.service),
    property = trim(form.property),
    height = trim(form.height),
    opening = trim(form.opening),
    contactMethod = trim(form.contact_method),
    notes = trim(form.notes),
    submittedAt = now(),
    ipAddress = CGI.REMOTE_ADDR
}>

<!--- Server-side validation. --->
<cfset errors = []>

<cfif len(quote.fullname) LT 2>
    <cfset arrayAppend(errors, "Please enter your full name.")>
</cfif>

<cfif NOT reFind("^[0-9+() -]{7,20}$", quote.mobile)>
    <cfset arrayAppend(errors, "Please enter a valid mobile number.")>
</cfif>

<cfif len(quote.email) AND NOT isValid("email", quote.email)>
    <cfset arrayAppend(errors, "Please enter a valid email address.")>
</cfif>

<cfif len(quote.city) LT 2>
    <cfset arrayAppend(errors, "Please enter your city or municipality.")>
</cfif>

<cfset allowedServices = "Supply Only,Supply + Installation">
<cfif NOT listFindNoCase(allowedServices, quote.service)>
    <cfset arrayAppend(errors, "Please select a valid service.")>
</cfif>

<cfset allowedProperties = "House,Townhouse,Condominium,Office,Other">
<cfif NOT listFindNoCase(allowedProperties, quote.property)>
    <cfset arrayAppend(errors, "Please select a valid property type.")>
</cfif>

<cfset allowedHeights = "Less than 2.4 m,2.4-3.0 m,Over 3.0 m,Not Sure">
<cfif NOT listFindNoCase(allowedHeights, quote.height)>
    <cfset arrayAppend(errors, "Please select a valid ceiling height.")>
</cfif>

<cfset allowedOpenings = "Existing Opening,Need New Opening,Not Sure,70cm x 90cm,70cm x 100cm,70cm x 120cm,80cm x 100cm,80cm x 120cm">
<cfif NOT listFindNoCase(allowedOpenings, quote.opening)>
    <cfset arrayAppend(errors, "Please select a valid opening option.")>
</cfif>

<cfif arrayLen(errors)>
    <cfheader statuscode="400" statustext="Bad Request">
    <!doctype html>
    <html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Please check your form</title>
        <link href="css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <main class="container py-5">
            <div class="card border-0 shadow-sm mx-auto" style="max-width:700px;">
                <div class="card-body p-4 p-md-5">
                    <h1 class="h3 mb-3">Please check your information</h1>
                    <ul class="text-danger mb-4">
                        <cfoutput>
                            <cfloop array="#errors#" index="errorMessage">
                                <li>#encodeForHTML(errorMessage)#</li>
                            </cfloop>
                        </cfoutput>
                    </ul>
                    <a class="btn btn-dark" href="<cfoutput>#encodeForHTMLAttribute(settings.formPage)#</cfoutput>" onclick="history.back(); return false;">Return to the form</a>
                </div>
            </div>
        </main>
    </body>
    </html>
    <cfabort>
</cfif>

<!--- Keep base paths separate from the submission-date paths. --->
<cfset uploadedFiles = []>
<cfset uploadDatePath = dateFormat(quote.submittedAt, "yyyy/mm/dd")>
<cfset datedUploadFolder = settings.uploadFolder & "/" & uploadDatePath>
<cfset datedUploadUrl = settings.uploadUrl & "/" & uploadDatePath>
<!--- Isolate partial uploads so cleanup cannot touch another submission. --->
<cfset uploadSubmissionId = createUUID()>
<cfset stagingUploadFolder = getTempDirectory() & "quote-request-" & uploadSubmissionId>

<cftry>
    <cfset directoryCreate(stagingUploadFolder)>
    <!--- Lucee fileUploadAll has no file-field argument: it processes all uploaded file fields.
          This form has only the photos field, with multiple enabled. --->
    <cfset uploadResults = fileUploadAll(
        destination = stagingUploadFolder,
        accept = "image/jpeg,image/png,image/webp,application/pdf",
        nameConflict = "makeunique",
        strict = true,
        allowedExtensions = settings.allowedExtensions
    )>

    <cfif arrayLen(uploadResults) GT settings.maxFiles>
        <cfthrow message="Please upload no more than 5 files.">
    </cfif>

    <!--- Validate the entire batch before publishing any files. --->
    <cfloop array="#uploadResults#" index="uploadResult">
        <cfif NOT listFindNoCase(settings.allowedExtensions, lCase(uploadResult.serverFileExt))>
            <cfthrow message="Unsupported file type.">
        </cfif>
        <cfif uploadResult.fileSize GT settings.maxFileSizeBytes>
            <cfthrow message="Each uploaded file must be 5 MB or smaller.">
        </cfif>
    </cfloop>

    <cfif arrayLen(uploadResults)>
        <cfset directoryCreate(datedUploadFolder, true, true)>
    </cfif>
    <cfloop array="#uploadResults#" index="uploadResult">
        <!--- Request-unique names prevent overwriting previous submissions. --->
        <cfset savedName = uploadSubmissionId & "-" & uploadResult.serverFile>
        <cfset savedFilePath = datedUploadFolder & "/" & savedName>
        <cffile action="move"
            source="#stagingUploadFolder & '/' & uploadResult.serverFile#"
            destination="#savedFilePath#" nameconflict="error">
        <cfset arrayAppend(uploadedFiles, {
            path = savedFilePath,
            originalName = uploadResult.clientFile,
            savedName = savedName
        })>
    </cfloop>

    <cfcatch type="any">
        <cfset uploadErrorMessage = cfcatch.message>
        <!--- Roll back only files successfully moved by this submission. --->
        <cfloop array="#uploadedFiles#" index="uploadedFile">
            <cftry>
                <cfif fileExists(uploadedFile.path)>
                    <cfset fileDelete(uploadedFile.path)>
                </cfif>
                <cfcatch type="any">
                    <cflog file="attic-ladder-quotes" type="error" text="Quote upload cleanup failed: #cfcatch.message#">
                </cfcatch>
            </cftry>
        </cfloop>
        <cfheader statuscode="400" statustext="Bad Request">
        <cfoutput>
            <!doctype html>
            <html lang="en">
            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Photo upload problem</title>
                <link href="css/bootstrap.min.css" rel="stylesheet">
            </head>
            <body class="bg-light">
                <main class="container py-5">
                    <div class="card border-0 shadow-sm mx-auto" style="max-width:700px;">
                        <div class="card-body p-4 p-md-5">
                            <h1 class="h3 mb-3">We could not upload one of your files</h1>
                            <p class="text-muted">#encodeForHTML(uploadErrorMessage)#</p>
                            <p>Please upload up to 5 JPG, PNG, WEBP, or PDF files no larger than 5 MB each.</p>
                            <a class="btn btn-dark" href="#encodeForHTMLAttribute(settings.formPage)#" onclick="history.back(); return false;">Return to the form</a>
                        </div>
                    </div>
                </main>
            </body>
            </html>
        </cfoutput>
        <cfabort>
    </cfcatch>
    <cffinally>
        <!--- Also removes partial files when fileUploadAll throws mid-batch. --->
        <cftry>
            <cfif directoryExists(stagingUploadFolder)>
                <cfset directoryDelete(stagingUploadFolder, true)>
            </cfif>
            <cfcatch type="any">
                <cflog file="attic-ladder-quotes" type="error" text="Quote staging cleanup failed: #cfcatch.message#">
            </cfcatch>
        </cftry>
    </cffinally>
</cftry>

<!--- Build safe email content. --->
<cfsavecontent variable="businessEmailBody">
<cfoutput>
<!doctype html>
<html>
<body style="font-family:Arial,sans-serif;color:##212529;line-height:1.6;">
    <h2 style="margin-bottom:6px;">New Quote Request</h2>
    <p style="color:##6c757d;margin-top:0;">Submitted #dateFormat(quote.submittedAt, "mmmm d, yyyy")# at #timeFormat(quote.submittedAt, "h:mm tt")#</p>

    <table cellpadding="8" cellspacing="0" style="border-collapse:collapse;width:100%;max-width:700px;">
        <tr><td style="font-weight:bold;border-bottom:1px solid ##eee;width:210px;">Name</td><td style="border-bottom:1px solid ##eee;">#encodeForHTML(quote.fullname)#</td></tr>
        <tr><td style="font-weight:bold;border-bottom:1px solid ##eee;">Mobile</td><td style="border-bottom:1px solid ##eee;">#encodeForHTML(quote.mobile)#</td></tr>
        <tr><td style="font-weight:bold;border-bottom:1px solid ##eee;">Email</td><td style="border-bottom:1px solid ##eee;">#encodeForHTML(quote.email)#</td></tr>
        <tr><td style="font-weight:bold;border-bottom:1px solid ##eee;">City / Municipality</td><td style="border-bottom:1px solid ##eee;">#encodeForHTML(quote.city)#</td></tr>
        <tr><td style="font-weight:bold;border-bottom:1px solid ##eee;">Preferred Contact</td><td style="border-bottom:1px solid ##eee;">#encodeForHTML(quote.contactMethod)#</td></tr>
        <tr><td style="font-weight:bold;border-bottom:1px solid ##eee;">Service Required</td><td style="border-bottom:1px solid ##eee;">#encodeForHTML(quote.service)#</td></tr>
        <tr><td style="font-weight:bold;border-bottom:1px solid ##eee;">Property Type</td><td style="border-bottom:1px solid ##eee;">#encodeForHTML(quote.property)#</td></tr>
        <tr><td style="font-weight:bold;border-bottom:1px solid ##eee;">Ceiling Height</td><td style="border-bottom:1px solid ##eee;">#encodeForHTML(quote.height)#</td></tr>
        <tr><td style="font-weight:bold;border-bottom:1px solid ##eee;">Ceiling Opening</td><td style="border-bottom:1px solid ##eee;">#encodeForHTML(quote.opening)#</td></tr>
        <tr><td style="font-weight:bold;border-bottom:1px solid ##eee;">Uploaded Files</td><td style="border-bottom:1px solid ##eee;">#arrayLen(uploadedFiles)#</td></tr>
        <cfif arrayLen(uploadedFiles)>
            <tr>
                <td style="font-weight:bold;border-bottom:1px solid ##eee;vertical-align:top;">Photos / Files</td>
                <td style="border-bottom:1px solid ##eee;">
                    <cfloop array="#uploadedFiles#" index="uploadedFile">
                        <a href="#encodeForHTMLAttribute(datedUploadUrl & "/" & urlEncodedFormat(uploadedFile.savedName))#">
                            #encodeForHTML(uploadedFile.originalName)#
                        </a><br>
                    </cfloop>
                </td>
            </tr>
        </cfif>
        <tr><td style="font-weight:bold;vertical-align:top;">Additional Notes</td><td>#replace(encodeForHTML(quote.notes), chr(10), "<br>", "all")#</td></tr>
    </table>

    <p style="margin-top:24px;color:##6c757d;font-size:13px;">IP address: #encodeForHTML(quote.ipAddress)#</p>
</body>
</html>
</cfoutput>
</cfsavecontent>

<!--- Send the business notification. SMTP should be configured in the CF Administrator. --->
<cftry>
    <cfmail
        to="#settings.quoteRecipient#"
        from="#settings.fromEmail#"
        replyto="#len(quote.email) ? quote.email : settings.replyToEmail#"
        attributeCollection="#application.smtp.mailAttributes#"
        subject="New quote request - #quote.fullname# - #quote.city#"
        type="html">
        #businessEmailBody#
    </cfmail>

    <!--- Optional confirmation email when the customer provides an email address. --->
    <cfif len(quote.email)>
        <cfmail
            to="#quote.email#"
            from="#settings.fromEmail#"
            replyto="#settings.replyToEmail#"
            attributeCollection="#application.smtp.mailAttributes#"
            subject="We received your quote request - #settings.businessName#"
            type="html">
            <cfoutput>
                <!doctype html>
                <html>
                <body style="font-family:Arial,sans-serif;color:##212529;line-height:1.6;">
                    <h2>Thank you, #encodeForHTML(quote.fullname)#.</h2>
                    <p>We received your request for a free attic ladder quotation.</p>
                    <p>Our team will review the details and contact you using your preferred method.</p>
                    <p><strong>Service:</strong> #encodeForHTML(quote.service)#<br>
                    <strong>Location:</strong> #encodeForHTML(quote.city)#</p>
                    <p>Regards,<br><strong>#encodeForHTML(settings.businessName)#</strong></p>
                </body>
                </html>
            </cfoutput>
        </cfmail>
    </cfif>

    <cfcatch type="any">
        <!--- Log the technical details without exposing them publicly. --->
        <cflog file="attic-ladder-quotes" type="error" text="Quote email failed: #cfcatch.message# | #cfcatch.detail#">
        <cfheader statuscode="500" statustext="Internal Server Error">
        <!doctype html>
        <html lang="en">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Unable to send request</title>
            <link href="css/bootstrap.min.css" rel="stylesheet">
        </head>
        <body class="bg-light">
            <main class="container py-5">
                <div class="card border-0 shadow-sm mx-auto" style="max-width:700px;">
                    <div class="card-body p-4 p-md-5">
                        <h1 class="h3 mb-3">Your request could not be sent</h1>
                        <p class="text-muted">Please try again, or call Attic Ladder PH directly. 0977-849-7190</p>
                        <a class="btn btn-dark" href="<cfoutput>#encodeForHTMLAttribute(settings.formPage)#</cfoutput>">Return to the form</a>
                    </div>
                </div>
            </main>
        </body>
        </html>
        <cfabort>
    </cfcatch>
</cftry>

<cflocation url="#settings.thankYouPage#" addtoken="false">
