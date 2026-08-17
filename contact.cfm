<cfset activeNav = "contact">

<cfinclude template="inc_header.cfm">

<body class="d-flex flex-column min-vh-100">

<main class="flex-shrink-0">

    <cfinclude template="inc_nav.cfm">

    <!-- =====================================================
         CONTACT PAGE HERO
    ====================================================== -->
    <section class="contact-hero">
        <div class="container px-4 px-lg-5">
            <div class="row justify-content-center">
                <div class="col-lg-9 text-center">

                    <span class="contact-eyebrow">
                        We're here to help
                    </span>

                    <h1 class="display-5 fw-bold mb-3">
                        Contact Attic Ladder PH
                    </h1>

                    <p class="lead mb-0">
                        Have questions about our products, supply options,
                        or installation services? Send us a message and our
                        team will get back to you.
                    </p>

                </div>
            </div>
        </div>
    </section>


    <!-- =====================================================
         CONTACT CONTENT
    ====================================================== -->
    <section class="contact-section py-5">

        <div class="container px-4 px-lg-5">

            <!-- Quote Redirect Banner -->
            <div class="quote-banner mb-5">

                <div>
                    <span class="quote-banner-label">
                        Looking for pricing?
                    </span>

                    <h2 class="h4 fw-bold mb-1">
                        Request a personalized attic ladder quotation.
                    </h2>

                    <p class="mb-0">
                        Provide your project details and photos so we can
                        recommend the most suitable option.
                    </p>
                </div>

                <a href="quoterequest.cfm" class="btn btn-gold">
                    Request a Free Quote
                    <i class="bi bi-arrow-right ms-2"></i>
                </a>

            </div>


            <div class="row g-4 g-lg-5 align-items-stretch">

                <!-- =========================================
                     LEFT COLUMN: CONTACT INFORMATION
                ========================================== -->
                <div class="col-lg-5">

                    <div class="contact-details-panel h-100">

                        <span class="contact-section-label">
                            Contact information
                        </span>

                        <h2 class="fw-bold mb-3">
                            Let's talk about your project
                        </h2>

                        <p class="contact-intro mb-4">
                            Reach us through the channel most convenient
                            for you. For faster product assessment, you
                            may also send photos of your ceiling area
                            through Messenger.
                        </p>


                        <!-- Phone -->
                        <a href="tel:+639778497190"
                           class="contact-detail-item">

                            <span class="contact-detail-icon">
                                <i class="bi bi-telephone-fill"></i>
                            </span>

                            <span>
                                <small>Call or text</small>
                                <strong>0977 849 7190</strong>
                            </span>

                        </a>


                        <!-- Messenger -->
                        <a href="https://www.facebook.com/messages/t/AtticLadderPH"
                           target="_blank"
                           rel="noopener"
                           class="contact-detail-item">

                            <span class="contact-detail-icon">
                                <i class="bi bi-messenger"></i>
                            </span>

                            <span>
                                <small>Facebook Messenger</small>
                                <strong>Message Attic Ladder PH</strong>
                            </span>

                        </a>


                        <!-- Email -->
                        <a href="mailto:sales@atticladderph.com"
                           class="contact-detail-item">

                            <span class="contact-detail-icon">
                                <i class="bi bi-envelope-fill"></i>
                            </span>

                            <span>
                                <small>Email</small>
                                <strong>sales@atticladderph.com</strong>
                            </span>

                        </a>


                        <!-- Location -->
                        <div class="contact-detail-item">

                            <span class="contact-detail-icon">
                                <i class="bi bi-geo-alt-fill"></i>
                            </span>

                            <span>
                                <small>Business location</small>
                                <strong>Bacoor City, Cavite</strong>
                                <span class="contact-detail-description">
                                    Nationwide supply and installation
                                    services in selected areas.
                                </span>
                            </span>

                        </div>


                        <!-- Business Hours -->
                        <div class="contact-detail-item">

                            <span class="contact-detail-icon">
                                <i class="bi bi-clock-fill"></i>
                            </span>

                            <span>
                                <small>Business hours</small>
                                <strong>Monday-Saturday</strong>
                                <span class="contact-detail-description">
                                    8:00 AM-5:00 PM
                                </span>
                            </span>

                        </div>


                        <div class="response-note">
                            <i class="bi bi-chat-square-text-fill"></i>

                            <span>
                                We typically respond within one business day.
                            </span>
                        </div>

                    </div>

                </div>


                <!-- =========================================
                     RIGHT COLUMN: CONTACT FORM
                ========================================== -->
                <div class="col-lg-7">

                    <div class="contact-form-card">

                        <div class="mb-4">
                            <span class="contact-section-label">
                                General inquiries
                            </span>

                            <h2 class="fw-bold mb-2">
                                Send Us a Message
                            </h2>

                            <p class="text-muted mb-0">
                                Complete the form below and we'll respond
                                as soon as possible.
                            </p>
                        </div>


                        <!-- Message containers -->
                        <div id="successMessage"
                             class="alert alert-success contact-alert"
                             role="alert"
                             style="display:none;">

                            <i class="bi bi-check-circle-fill me-2"></i>

                            <span>
                                Thank you! Your message has been received.
                                We'll get back to you within one business day.
                            </span>

                        </div>

                        <div id="errorMessage"
                             class="alert alert-danger contact-alert"
                             role="alert"
                             style="display:none;">

                            <i class="bi bi-exclamation-circle-fill me-2"></i>

                            <span id="errorMessageText">
                                We couldn't submit your message. Please try again.
                            </span>

                        </div>


                        <form id="contactForm"
                              method="post"
                              autocomplete="on">

                            <div class="row g-3">

                                <!-- Full Name -->
                                <div class="col-md-6">

                                    <label for="name" class="form-label">
                                        Full Name
                                        <span class="required-mark">*</span>
                                    </label>

                                    <input
                                        type="text"
                                        class="form-control"
                                        id="name"
                                        name="name"
                                        placeholder="Juan Dela Cruz"
                                        maxlength="150"
                                        autocomplete="name"
                                        required>

                                </div>


                                <!-- Mobile -->
                                <div class="col-md-6">

                                    <label for="mobile" class="form-label">
                                        Mobile Number
                                        <span class="required-mark">*</span>
                                    </label>

                                    <input
                                        type="tel"
                                        class="form-control"
                                        id="mobile"
                                        name="mobile"
                                        placeholder="0917 123 4567"
                                        maxlength="30"
                                        autocomplete="tel"
                                        required>

                                </div>


                                <!-- Email -->
                                <div class="col-md-6">

                                    <label for="email" class="form-label">
                                        Email Address
                                        <span class="required-mark">*</span>
                                    </label>

                                    <input
                                        type="email"
                                        class="form-control"
                                        id="email"
                                        name="email"
                                        placeholder="juan@email.com"
                                        maxlength="255"
                                        autocomplete="email"
                                        required>

                                </div>


                                <!-- Company -->
                                <div class="col-md-6">

                                    <label for="company" class="form-label">
                                        Company
                                        <span class="optional-label">
                                            Optional
                                        </span>
                                    </label>

                                    <input
                                        type="text"
                                        class="form-control"
                                        id="company"
                                        name="company"
                                        placeholder="Company name"
                                        maxlength="150"
                                        autocomplete="organization">

                                </div>


                                <!-- Subject -->
                                <div class="col-12">

                                    <label for="subject" class="form-label">
                                        What can we help you with?
                                        <span class="required-mark">*</span>
                                    </label>

                                    <select
                                        class="form-select"
                                        id="subject"
                                        name="subject"
                                        required>

                                        <option value="" selected disabled>
                                            Select an inquiry type
                                        </option>

                                        <option value="General Inquiry">
                                            General Inquiry
                                        </option>

                                        <option value="Product Information">
                                            Product Information
                                        </option>

                                        <option value="Supply Only">
                                            Supply Only
                                        </option>

                                        <option value="Installation Inquiry">
                                            Installation Inquiry
                                        </option>

                                        <option value="After-Sales Support">
                                            After-Sales Support
                                        </option>

                                        <option value="Other">
                                            Other
                                        </option>

                                    </select>

                                </div>


                                <!-- Message -->
                                <div class="col-12">

                                    <label for="message" class="form-label">
                                        Message
                                        <span class="required-mark">*</span>
                                    </label>

                                    <textarea
                                        class="form-control"
                                        id="message"
                                        name="message"
                                        rows="6"
                                        maxlength="3000"
                                        placeholder="Tell us how we can help..."
                                        required></textarea>

                                    <div class="form-text text-end">
                                        <span id="messageCount">0</span>/3000
                                    </div>

                                </div>


                                <!-- Honeypot -->
                                <div class="contact-honeypot"
                                     aria-hidden="true">

                                    <label for="website">
                                        Website
                                    </label>

                                    <input
                                        type="text"
                                        id="website"
                                        name="website"
                                        tabindex="-1"
                                        autocomplete="off">

                                </div>


                                <!-- Existing ColdFusion CAPTCHA -->
                                <div class="col-12">

                                    <label for="captcha" class="form-label">
                                        Security Verification
                                        <span class="required-mark">*</span>
                                    </label>

                                    <div class="captcha-wrapper">

                                        <iframe
                                            id="frameCaptcha"
                                            src="generate_captcha.cfm"
                                            title="CAPTCHA verification image"
                                            width="300"
                                            height="100"
                                            scrolling="no"
                                            frameborder="0">
                                        </iframe>

                                        <button
                                            type="button"
                                            class="captcha-refresh"
                                            id="refreshCaptcha"
                                            aria-label="Refresh CAPTCHA">

                                            <i class="bi bi-arrow-clockwise"></i>
                                            Refresh

                                        </button>

                                    </div>

                                    <input
                                        type="text"
                                        class="form-control captcha-input"
                                        id="captcha"
                                        name="captcha"
                                        placeholder="Enter the characters shown above"
                                        maxlength="20"
                                        autocomplete="off"
                                        required>

                                </div>


                                <!-- Submit -->
                                <div class="col-12 pt-2">

                                    <button
                                        type="submit"
                                        class="btn btn-gold btn-lg w-100"
                                        id="contactSubmit">

                                        <span class="submit-label">
                                            Send Message
                                        </span>

                                        <span class="submit-loading"
                                              style="display:none;">

                                            <span
                                                class="spinner-border spinner-border-sm me-2"
                                                aria-hidden="true">
                                            </span>

                                            Sending...

                                        </span>

                                        <i class="bi bi-arrow-right ms-2 submit-arrow"></i>

                                    </button>

                                </div>

                            </div>

                        </form>


                        <p class="contact-privacy-note">
                            <i class="bi bi-lock-fill me-1"></i>
                            Your information will only be used to respond
                            to your inquiry.
                        </p>

                    </div>

                </div>

            </div>

        </div>

    </section>

</main>

<cfinclude template="inc_footer.cfm">


<!-- jQuery -->
<script
    src="https://code.jquery.com/jquery-3.7.1.min.js"
    integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
    crossorigin="anonymous">
</script>


<script>
$(document).ready(function () {

    const $form = $("#contactForm");
    const $submit = $("#contactSubmit");
    const $success = $("#successMessage");
    const $error = $("#errorMessage");
    const $errorText = $("#errorMessageText");
    const $message = $("#message");


    function refreshCaptcha() {
        const captchaUrl =
            "generate_captcha.cfm?t=" + new Date().getTime();

        $("#frameCaptcha").attr("src", captchaUrl);
        $("#captcha").val("");
    }


    $("#refreshCaptcha").on("click", function () {
        refreshCaptcha();
    });


    $message.on("input", function () {
        $("#messageCount").text($(this).val().length);
    });


    $form.on("submit", function (event) {

        event.preventDefault();

        $success.hide();
        $error.hide();

        if (!this.checkValidity()) {
            this.reportValidity();
            return;
        }


        const formData = {
            name: $.trim($("#name").val()),
            mobile: $.trim($("#mobile").val()),
            email: $.trim($("#email").val()),
            company: $.trim($("#company").val()),
            subject: $("#subject").val(),
            message: $.trim($("#message").val()),
            canswer: $.trim($("#captcha").val()),
            website: $.trim($("#website").val())
        };


        $submit.prop("disabled", true);
        $submit.find(".submit-label").hide();
        $submit.find(".submit-arrow").hide();
        $submit.find(".submit-loading").show();


        $.ajax({

            url: "contact.cfc?method=fnContactForm",
            type: "POST",
            cache: false,
            dataType: "text",
            data: formData,

            success: function (response) {

                const cleanedResponse =
                    $.trim(String(response))
                        .replace(/^"|"$/g, "");

                if (
                    cleanedResponse.toLowerCase() === "success" ||
                    cleanedResponse === "1" ||
                    cleanedResponse.toLowerCase() === "true"
                ) {

                    $form[0].reset();
                    $("#messageCount").text("0");

                    refreshCaptcha();

                    $success
                        .stop(true, true)
                        .fadeIn(200);

                    $("html, body").animate({
                        scrollTop:
                            $success.offset().top - 120
                    }, 400);

                } else {

                    let message =
                        "We couldn't submit your message. Please check the CAPTCHA and try again.";

                    if (cleanedResponse.length > 0 &&
                        cleanedResponse.length < 300) {
                        message = cleanedResponse;
                    }

                    $errorText.text(message);
                    $error.fadeIn(200);

                    refreshCaptcha();
                }

            },

            error: function (xhr) {

                let message =
                    "An error occurred while submitting your message. Please try again.";

                if (xhr.status === 429) {
                    message =
                        "Too many requests were submitted. Please wait a moment and try again.";
                }

                $errorText.text(message);
                $error.fadeIn(200);

                refreshCaptcha();
            },

            complete: function () {

                $submit.prop("disabled", false);
                $submit.find(".submit-label").show();
                $submit.find(".submit-arrow").show();
                $submit.find(".submit-loading").hide();

            }

        });

    });

});
</script>

</body>