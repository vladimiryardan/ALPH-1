<cfcomponent output="false">

    <cffunction
        name="fnContactForm"
        access="remote"
        returntype="string"
        returnformat="plain"
        output="false">

        <cfsetting showdebugoutput="false">

        <!--- Form arguments --->
        <cfargument name="name" type="string" required="true">
        <cfargument name="mobile" type="string" required="true">
        <cfargument name="email" type="string" required="true">
        <cfargument name="company" type="string" required="false" default="">
        <cfargument name="subject" type="string" required="true">
        <cfargument name="message" type="string" required="true">
        <cfargument name="recaptchaToken" type="string" required="true">
        <cfargument name="website" type="string" required="false" default="">

       

            <!--- Trim submitted values --->
            <cfset local.fullName = trim(arguments.name)>
            <cfset local.mobile = trim(arguments.mobile)>
            <cfset local.email = trim(arguments.email)>
            <cfset local.company = trim(arguments.company)>
            <cfset local.subject = trim(arguments.subject)>
            <cfset local.message = trim(arguments.message)>
            <cfset local.recaptchaToken = trim(arguments.recaptchaToken)>
            <cfset local.honeypot = trim(arguments.website)>


            <!--- Honeypot spam protection --->
            <cfif len(local.honeypot)>
                <cflog
                    file="atticladderph-contact"
                    type="Information"
                    text="Contact spam blocked by honeypot. IP: #cgi.remote_addr#">

                <cfreturn "Invalid submission.">
            </cfif>


            <!--- Required field validation --->
            <cfif NOT len(local.fullName)>
                <cfreturn "Please enter your full name.">
            </cfif>

            <cfif NOT len(local.mobile)>
                <cfreturn "Please enter your mobile number.">
            </cfif>

            <cfif NOT len(local.email) OR NOT isValid("email", local.email)>
                <cfreturn "Please enter a valid email address.">
            </cfif>

            <cfif NOT len(local.subject)>
                <cfreturn "Please select an inquiry type.">
            </cfif>

            <cfif NOT len(local.message)>
                <cfreturn "Please enter your message.">
            </cfif>

            <cfif len(local.message) GT 3000>
                <cfreturn "Your message must not exceed 3,000 characters.">
            </cfif>


            <!---
                Google reCAPTCHA v2 server-side verification
            --->
            <cfif NOT len(local.recaptchaToken)>
                <cfreturn "Please complete the reCAPTCHA verification.">
            </cfif>

            <cfhttp
                url="https://www.google.com/recaptcha/api/siteverify"
                method="post"
                result="local.recaptchaHttpResult"
                throwonerror="false">

                <cfhttpparam type="formfield" name="secret" value="#application.recaptcha.secretKey#">
                <cfhttpparam type="formfield" name="response" value="#local.recaptchaToken#">
                <cfhttpparam type="formfield" name="remoteip" value="#cgi.remote_addr#">

            </cfhttp>

            <cfset local.recaptchaResult = {}>

            <cftry>
                <cfset local.recaptchaResult = deserializeJSON(local.recaptchaHttpResult.fileContent)>

                <cfcatch type="any">
                    <cfset local.recaptchaResult = { success = false }>
                </cfcatch>
            </cftry>

            <cfif NOT (structKeyExists(local.recaptchaResult, "success") AND local.recaptchaResult.success)>
                <cflog
                    file="atticladderph-contact"
                    type="Information"
                    text="Contact reCAPTCHA verification failed. IP: #cgi.remote_addr#">

                <cfreturn "The reCAPTCHA verification failed. Please try again.">
            </cfif>


            <!--- Escape values for safe HTML email output --->
            <cfset local.safeName = encodeForHTML(local.fullName)>
            <cfset local.safeMobile = encodeForHTML(local.mobile)>
            <cfset local.safeEmail = encodeForHTML(local.email)>
            <cfset local.safeCompany = encodeForHTML(local.company)>
            <cfset local.safeSubject = encodeForHTML(local.subject)>
            <cfset local.safeMessage = encodeForHTML(local.message)>
            <cfset local.safeMessage = replace(
                local.safeMessage,
                chr(10),
                "<br>",
                "all"
            )>


            <!--- Send notification to Attic Ladder PH --->
            <cfmail
                to="#application.smtp.toEmail#"
                from="#application.smtp.fromEmail#"
                replyto="#local.email#"
                attributeCollection="#application.smtp.mailAttributes#"
                subject="Website Contact: #local.subject#"
                type="html">

                <!doctype html>
                <html>
                <head>
                    <meta charset="utf-8">
                </head>

                <body style="margin:0;background:##f4f4f4;font-family:Arial,sans-serif;">

                    <table
                        width="100%"
                        cellpadding="0"
                        cellspacing="0"
                        style="background:##f4f4f4;padding:30px 15px;">

                        <tr>
                            <td align="center">

                                <table
                                    width="100%"
                                    cellpadding="0"
                                    cellspacing="0"
                                    style="
                                        max-width:680px;
                                        background:##ffffff;
                                        border-radius:12px;
                                        overflow:hidden;
                                    ">

                                    <tr>
                                        <td style="
                                            padding:26px 30px;
                                            background:##212529;
                                            color:##ffffff;
                                        ">

                                            <h1 style="
                                                margin:0;
                                                font-size:24px;
                                            ">
                                                New Contact Inquiry
                                            </h1>

                                            <p style="
                                                margin:8px 0 0;
                                                color:##d4a64a;
                                            ">
                                                Attic Ladder PH Website
                                            </p>

                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="
                                            padding:30px;
                                            color:##333333;
                                        ">

                                            <table
                                                width="100%"
                                                cellpadding="8"
                                                cellspacing="0"
                                                style="
                                                    border-collapse:collapse;
                                                ">

                                                <tr>
                                                    <td style="
                                                        width:170px;
                                                        font-weight:bold;
                                                        border-bottom:1px solid ##eeeeee;
                                                    ">
                                                        Full Name
                                                    </td>

                                                    <td style="
                                                        border-bottom:1px solid ##eeeeee;
                                                    ">
                                                        #local.safeName#
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td style="
                                                        font-weight:bold;
                                                        border-bottom:1px solid ##eeeeee;
                                                    ">
                                                        Mobile Number
                                                    </td>

                                                    <td style="
                                                        border-bottom:1px solid ##eeeeee;
                                                    ">
                                                        #local.safeMobile#
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td style="
                                                        font-weight:bold;
                                                        border-bottom:1px solid ##eeeeee;
                                                    ">
                                                        Email Address
                                                    </td>

                                                    <td style="
                                                        border-bottom:1px solid ##eeeeee;
                                                    ">
                                                        <a href="mailto:#local.safeEmail#">
                                                            #local.safeEmail#
                                                        </a>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td style="
                                                        font-weight:bold;
                                                        border-bottom:1px solid ##eeeeee;
                                                    ">
                                                        Company
                                                    </td>

                                                    <td style="
                                                        border-bottom:1px solid ##eeeeee;
                                                    ">
                                                        <cfif len(local.safeCompany)>
                                                            #local.safeCompany#
                                                        <cfelse>
                                                            Not provided
                                                        </cfif>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td style="
                                                        font-weight:bold;
                                                        border-bottom:1px solid ##eeeeee;
                                                    ">
                                                        Inquiry Type
                                                    </td>

                                                    <td style="
                                                        border-bottom:1px solid ##eeeeee;
                                                    ">
                                                        #local.safeSubject#
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td style="
                                                        font-weight:bold;
                                                        border-bottom:1px solid ##eeeeee;
                                                    ">
                                                        IP Address
                                                    </td>

                                                    <td style="
                                                        border-bottom:1px solid ##eeeeee;
                                                    ">
                                                        #encodeForHTML(cgi.remote_addr)#
                                                    </td>
                                                </tr>

                                            </table>

                                            <h2 style="
                                                margin:30px 0 12px;
                                                font-size:18px;
                                            ">
                                                Message
                                            </h2>

                                            <div style="
                                                padding:18px;
                                                background:##f8f7f4;
                                                border-left:4px solid ##d4a64a;
                                                line-height:1.7;
                                            ">
                                                #local.safeMessage#
                                            </div>

                                        </td>
                                    </tr>

                                </table>

                            </td>
                        </tr>

                    </table>

                </body>
                </html>

            </cfmail>


            <!--- Customer acknowledgment email --->
            <cfmail
                to="#local.email#"
                from="#application.smtp.fromEmail#"
                attributeCollection="#application.smtp.mailAttributes#"
                subject="We received your message — Attic Ladder PH"
                type="html">

                <!doctype html>
                <html>
                <head>
                    <meta charset="utf-8">
                </head>

                <body style="
                    margin:0;
                    background:##f4f4f4;
                    font-family:Arial,sans-serif;
                ">

                    <table
                        width="100%"
                        cellpadding="0"
                        cellspacing="0"
                        style="padding:30px 15px;">

                        <tr>
                            <td align="center">

                                <table
                                    width="100%"
                                    cellpadding="0"
                                    cellspacing="0"
                                    style="
                                        max-width:620px;
                                        background:##ffffff;
                                        border-radius:12px;
                                        overflow:hidden;
                                    ">

                                    <tr>
                                        <td style="
                                            padding:25px 30px;
                                            background:##212529;
                                            color:##ffffff;
                                        ">

                                            <h1 style="
                                                margin:0;
                                                font-size:23px;
                                            ">
                                                Attic Ladder PH
                                            </h1>

                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="
                                            padding:32px;
                                            color:##333333;
                                            line-height:1.7;
                                        ">

                                            <p>
                                                Hi #local.safeName#,
                                            </p>

                                            <p>
                                                Thank you for contacting
                                                Attic Ladder PH.
                                            </p>

                                            <p>
                                                We have received your message
                                                regarding
                                                <strong>#local.safeSubject#</strong>.
                                                Our team will review your inquiry
                                                and respond within one business day.
                                            </p>

                                            <p>
                                                For urgent concerns, you may call
                                                or text us at
                                                <strong>0977 849 7190</strong>.
                                            </p>

                                            <p style="margin-bottom:0;">
                                                Regards,<br>
                                                <strong>Attic Ladder PH Team</strong>
                                            </p>

                                        </td>
                                    </tr>

                                </table>

                            </td>
                        </tr>

                    </table>

                </body>
                </html>

            </cfmail>


            <!--- Log successful submission --->
            <cflog
                file="atticladderph-contact"
                type="Information"
                text="Contact inquiry submitted by #local.fullName# (#local.email#). Subject: #local.subject#">

            <cfreturn "Success">

            <cftry>                 
            <cfcatch type="any">

                <cflog
                    file="atticladderph-contact"
                    type="Error"
                    text="
                        fnContactForm failed.
                        Message: #cfcatch.message#
                        Detail: #cfcatch.detail#
                        IP: #cgi.remote_addr#
                    ">

                <cfreturn "We could not send your message right now. Please try again later.">

            </cfcatch>

        </cftry>

    </cffunction>

</cfcomponent>