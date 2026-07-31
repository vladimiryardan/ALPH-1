<cfinclude template="inc_header.cfm">
<body class="d-flex flex-column min-vh-100 bg-light">
    <main class="flex-grow-1">
        <cfinclude template="inc_nav.cfm">

        <section class="py-5">
            <div class="container px-4 px-lg-5 py-lg-5">
                <div class="card border-0 shadow-sm mx-auto text-center" style="max-width:720px;border-radius:18px;">
                    <div class="card-body p-4 p-md-5">
                        <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-4"
                             style="width:76px;height:76px;background:#d4a64a;color:#212529;font-size:32px;">
                            <i class="bi bi-check-lg"></i>
                        </div>

                        <h1 class="fw-bold mb-3">Quote Request Received</h1>
                        <p class="lead text-muted mb-4">
                            Thank you for contacting Attic Ladder PH. Our team will review your project details and get in touch with you shortly.
                        </p>

                        <a href="index.cfm" class="btn btn-dark btn-lg px-4">Return to Home</a>
                    </div>
                </div>
            </div>
        </section>
    </main>
</body>
</html>
