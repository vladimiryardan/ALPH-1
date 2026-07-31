 <cfinclude template = "inc_header.cfm">

<cfset hideFooter = true>
<cfset hideFloatingContact = true>

  <!--
    ############
    body
    ############
  -->
  <body class="d-flex flex-column h-100">
    <main class="flex-shrink-0">
      <cfinclude template = "inc_nav.cfm">

      
      <!-- 
      ############
      quote Form
      ############
      -->
      <section class="mb-5">

    <div class="row text-center justify-content-center">

        <div class="col-md-4 mb-4">

            <div class="process-step">

                <div class="process-icon">
                    <i class="bi bi-chat-square-text-fill"></i>
                </div>

                <h5 class="mt-3 mb-2 fw-bold">
                    Tell Us About Your Project
                </h5>

                <p class="text-muted mb-0">
                    Complete the short form and upload photos of your installation area.
                </p>

            </div>

        </div>

        <div class="col-md-4 mb-4">

            <div class="process-step">

                <div class="process-icon">
                    <i class="bi bi-search"></i>
                </div>

                <h5 class="mt-3 mb-2 fw-bold">
                    We Review Your Requirements
                </h5>

                <p class="text-muted mb-0">
                    Our team evaluates your project and recommends the best attic ladder solution.
                </p>

            </div>

        </div>

        <div class="col-md-4 mb-4">

            <div class="process-step">

                <div class="process-icon">
                   <i class="bi bi-file-earmark-check-fill"></i>
                </div>

                <h5 class="mt-3 mb-2 fw-bold">
                    Receive Your Free Quote
                </h5>

                <p class="text-muted mb-0">
                    We'll send you a personalized quotation and answer any questions you may have.
                </p>

            </div>

        </div>

    </div>

</section>
<section class="process-section py-4 ">
    <div class="container px-5 my-4">

        <div class="row justify-content-center">
            <div class="col-xl-9">

                <div class="text-center mb-5">
                    <h1 class="fw-bold">Request a Free Quote</h1>

                    <p class="lead text-muted">
                        Tell us about your project and we'll recommend the
                        best attic ladder solution for your home.
                    </p>
                </div>

                <div class="card shadow-sm border-0 rounded-4">

                    <div class="card-body p-5">

                        <form action="quote_process.cfm" method="post" enctype="multipart/form-data">

                            <div style="position:absolute; left:-9999px; top:auto; width:1px; height:1px; overflow:hidden;" aria-hidden="true">
                                <!--- honeypot --->
                                <label for="website">Leave this empty</label>
                                <input type="text" id="website" name="website" tabindex="-1" autocomplete="off">
                            </div>

                            <h4 class="mb-4">Your Information</h4>

                            <div class="row">

                                <div class="col-md-6 mb-4">
                                    <label class="form-label">Full Name *</label>
                                    <input type="text" class="form-control" name="fullname" required>
                                </div>

                                <div class="col-md-6 mb-4">
                                    <label class="form-label">Mobile Number *</label>
                                    <input type="text" class="form-control" name="mobile" required>
                                </div>

                                <div class="col-md-6 mb-4">
                                    <label class="form-label">Email Address</label>
                                    <input type="email" class="form-control" name="email">
                                </div>

                                <div class="col-md-6 mb-4">
                                    <label class="form-label">City / Municipality</label>
                                    <input type="text" class="form-control" name="city" >
                                </div>

                            </div>

                            <hr class="my-5">

                            <h4 class="mb-4">Project Information</h4>

                            <div class="mb-4">

                                <label class="form-label">
                                    Service Required
                                </label>

                                <select class="form-select" name="service">

                                    <option value="Supply Only">Supply Only</option>
                                    <option>Supply + Installation</option>

                                </select>

                            </div>

                            <div class="mb-4">

                                <label class="form-label">
                                    Property Type
                                </label>

                                <select class="form-select" name="property">

                                    <option value="House">House</option>
                                    <option value="Townhouse">Townhouse</option>
                                    <option value="Condominium">Condominium</option>
                                    <option value="Office">Office</option>
                                    <option value="Other">Other</option>

                                </select>

                            </div>

                            <div class="mb-4">

                                <label class="form-label">
                                    Ceiling Height
                                </label>

                                <select class="form-select" name="height">

                                    <option value="Less than 8 ft">Less than 8 ft</option>
                                    <option value="8–10 ft">8–10 ft</option>
                                    <option value="Over 10 ft">Over 10 ft</option>
                                    <option value="Not Sure">Not Sure</option>

                                </select>

                            </div>

                            <div class="mb-4">

                                <label class="form-label">
                                    Existing Opening
                                </label>

                                <select class="form-select" name="opening">

                                    <option value="Existing Opening">Existing Opening</option>
                                    <option value="Need New Opening">Need New Opening</option>
                                    <option value="Not Sure">Not Sure</option>

                                </select>

                            </div>

                            <div class="mb-4">

                                <label class="form-label">
                                    Upload Photos
                                </label>

                                <input
                                    type="file"
                                    class="form-control"
                                    name="photos"
                                    multiple>

                                <div class="form-text">
                                    Photos of the ceiling or installation area
                                    help us provide a more accurate quotation.
                                </div>

                            </div>

                            <div class="mb-5">

                                <label class="form-label">
                                    Additional Notes
                                </label>

                                <textarea
                                    class="form-control"
                                    rows="5"
                                    name="notes"></textarea>

                            </div>

                            <div class="text-center">

                                <button
                                    type="submit"
                                    class="cta-btn mb-5">

                                    Request My Free Quote

                                </button>

                            </div>

                        </form>

                    </div>

                </div>

                <div class="hero-trust mt-5 text-center">

                    <span>
                        <i class="bi bi-check-circle-fill"></i>
                        Free Quotations
                    </span>

                    <span>
                        <i class="bi bi-check-circle-fill"></i>
                        Supply Nationwide
                    </span>

                    <span>
                        <i class="bi bi-check-circle-fill"></i>
                        Professional Installation
                    </span>

                </div>

            </div>

        </div>

    </div>
</section>
     
    </main>
   
 <cfinclude template = "inc_footer.cfm">