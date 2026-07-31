 <cfinclude template = "inc_header.cfm">

<cfset activeNav = "home"> 

  <!--
    ############
    body
    ############
  -->
  <body class="d-flex flex-column h-100">
    <main class="flex-shrink-0">
    
      <!---
      ############
      Navigation
      ############
      --->
      <cfinclude template = "inc_nav.cfm">

      <!-- 
      ############
      Header
      ############
      -->
      
      <header class="bg-dark py-5 pb-7">
        <div class="container px-5">
          <div class="row gx-5 align-items-center justify-content-center">
            <div class="col-lg-8 col-xl-7 col-xxl-6">
              <div class="my-5 text-center text-xl-start">
                <h1 class="display-5 fw-bolder text-white mb-2">
                  The Smart Way to
                  <br>
                  Access Your Attic
                </h1>
                <p class="lead fw-normal text-white-50 mb-4 hero-subtitle">
                  Premium attic ladder supply and installation, or supply only.
                  <!--- Premium attic ladder supply, or complete supply and professional installation. --->
                </p>

                 <div class="d-grid gap-3 d-sm-flex justify-content-sm-center justify-content-xl-start">
                                    <!--- <a class="btn btn-primary btn-lg px-4 me-sm-3" href="#features">Get Started</a> --->
                                    
                                    <a href="quoterequest.cfm" class="cta-btn mb-5">
                                        Request a Free Quote
                                        <span class="arrow">&rarr;</span>
                                    </a>
                                    
                                   <!---  <a class="btn btn-outline-light btn-lg px-4" href="#!">Learn More</a> --->
                 </div> 

<div class="hero-trust">
    <span><i class="bi bi-check-circle-fill"></i> Nationwide Supply</span>
    <span><i class="bi bi-check-circle-fill"></i> Supply & Installation</span>
    <span><i class="bi bi-check-circle-fill"></i> Free Quotations</span>
</div>

              </div>
            </div>
            <div class="col-xl-5 col-xxl-6 d-none d-xl-block text-center">
             <!---  <img
                class="img-fluid rounded-3 my-5"
                src="./images/attic-ladder-viewport.png"
                alt="..."
              /> --->
<!---               <img
                class="img-fluid rounded-3 my-5"
                src="./images/attic-ladder-main.png"
                alt="..."
              /> --->
            <img
                class="hero-product rounded-3"
                src="./images/attic-ladder-main.png"
                alt="Premium Attic Ladder">

              <!--src="./images/attic-ladder-main.png"
                -->
            </div>
          </div>
        </div>
      </header>
      <!-- 
      ############
      Features section
      ############
      -->
      <section class="py-5" id="features">
        <div class="container px-5 my-5">
          <div class="row gx-5">

            <div class="col-lg-12">
              <div class="row gx-5 row-cols-1 row-cols-md-2">
                <div class="col mb-5 h-100">
                  <div
                    class="feature bg-primary bg-gradient text-white rounded-3 mb-3"
                  >
                    <i class="bi bi-collection"></i>
                  </div>
                  <h2 class="h5">Retractable</h2>
                  <p class="mb-0">
                    Paragraph of text beneath the heading to explain the
                    heading. Here is just a bit more text.
                  </p>
                </div>
                <div class="col mb-5 h-100">
                  <div
                    class="feature bg-primary bg-gradient text-white rounded-3 mb-3"
                  >
                    <i class="bi bi-building"></i>
                  </div>
                  <h2 class="h5">Space Saving</h2>
                  <p class="mb-0">
                    Paragraph of text beneath the heading to explain the
                    heading. Here is just a bit more text.
                  </p>
                </div>
                <div class="col mb-5 mb-md-0 h-100">
                  <div
                    class="feature bg-primary bg-gradient text-white rounded-3 mb-3"
                  >
                    <i class="bi bi-hand-thumbs-up"></i>
                  </div>
                  <h2 class="h5">Easy To Operate</h2>
                  <p class="mb-0">
                    Paragraph of text beneath the heading to explain the
                    heading. Here is just a bit more text.
                  </p>
                </div>
                <div class="col h-100">
                  <div
                    class="feature bg-primary bg-gradient text-white rounded-3 mb-3"
                  >
                    <i class="bi bi-bricks"></i>
                  </div>
                  <h2 class="h5">Concealed</h2>
                  <p class="mb-0">
                    Paragraph of text beneath the heading to explain the
                    heading. Here is just a bit more text.
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
      <!-- 
      ############
      Testimonial section
      ############
      -->
      <div id="feedbacks-section" class="py-5 bg-light">
        <div class="container px-5 my-5">
          <div class="row gx-5 justify-content-center">
            <div class="col-lg-10 col-xl-7">
              <div class="text-center">
                <div class="feedback">
                  <i class="bi bi-chat-quote chat-quote-custom"></i>
                  <div class="fs-4 mb-4 fst-italic">
                    <!--- Option 1
                    It's time to start designing for our Home. <br>
                    Architects and Engineers enables our Living Spaces <br>
                    that fits the purpose, to improve our <br>
                    Quality of Life. --->
                    
                    <!--- option 2
                      A well-designed home is one that makes every space useful. An attic ladder is a simple addition that improves accessibility, maximizes storage, and enhances everyday living. --->
                    <!--- option 3 --->  
                    Great home design isn't just about appearance it's about making every square meter work for you. A quality attic ladder transforms unused ceiling space into practical storage that's safe and <br>easy to access.
                  </div>
                  <div class="white-line"></div>
                  <div class="d-flex align-items-center justify-content-center">
                    <!-- <img
                    class="rounded-circle me-3"
                    src="https://dummyimage.com/40x40/ced4da/6c757d"
                    alt="..."
                  /> -->

                    <div class="fw-bold">
                      Ar. Glenn Lim
                      <span class="fw-bold text-primary mx-1">|</span>
                      Attic Ladder Ph Customer
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- 
      ############
      Blog preview section
      ############
      -->
      <section class="py-5">
        <div class="container px-5 my-5">
          <div class="row gx-5 justify-content-center">
            <div class="col-lg-8 col-xl-6">
              <div class="text-center">
                <h2 class="fw-bolder">Attic Ideas & Home Tips</h2>
                <p class="lead fw-normal text-muted mb-5">
                  Practical advice on attic access, storage planning, ladder types, safety, and making better use of the space above your ceiling.
                </p>
              </div>
            </div>
          </div>
          <div class="row gx-5">
            <div class="col-lg-4 mb-5">
              <div class="card h-100 shadow border-0">
                <!---  src="./images/600x350_attic_ladder_types2.png" --->
                <img
                  class="card-img-top"                 
                  src="./images/attic_ladder_types 900x400.png"                  
                  alt="..."
                />
                <div class="card-body p-4">
                  <div class="badge-gold">
                    <i class="bi bi-book-half me-1"></i>
                    Product Guide
                  </div>
                  <a
                    class="text-decoration-none link-dark stretched-link"
                    href="attic_ladder_types.cfm"
                    ><h5 class="card-title mb-3">Types of Attic Ladders</h5></a
                  >
                  <p class="card-text mb-0">
                    While wood offers classic appeal and aluminum provides lightweight convenience, steel stands out as the most durable and reliable option. Learn why steel attic ladders are the best choice for safety, longevity, and functionality.
                  </p>
                </div>
                <div class="card-footer p-4 pt-0 bg-transparent border-top-0">
                  <div class="d-flex align-items-end justify-content-between">
                    <div class="d-flex align-items-center">
                      <img
                        class="rounded-circle me-3"
                        src="/images/vlad50x50.png"
                        alt="..."
                      />
                      <div class="small">
                        <div class="fw-bold">Vlad Y.</div>
                        <div class="text-muted">
                          March 12, 2022 &middot; 6 min read
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-lg-4 mb-5">
              <div class="card h-100 shadow border-0">
                <img
                  class="card-img-top"
                  src="/images/attic_ladder_luxuryofspace_900x400.png"
                  alt="..."
                />
                <div class="card-body p-4">
                  <div class="badge-gold">
                     <i class="bi bi-book-half me-1"></i>
                    Storage Tips
                  </div>
                  <a
                    class="text-decoration-none link-dark stretched-link"
                    href="attic_luxury_of_space.cfm"
                    ><h5 class="card-title mb-3">Luxury of Space</h5></a
                  >
                  <p class="card-text mb-0">
                    In a world of growing cities and limited resources, the luxury of space both physical and auditory is key to tackling overcrowding while enhancing the quality of life for all. Discover a vision for harmonious, sustainable cities that inspire and empower.
                  </p>
                </div>
                <div class="card-footer p-4 pt-0 bg-transparent border-top-0">
                  <div class="d-flex align-items-end justify-content-between">
                    <div class="d-flex align-items-center">
                      <img
                        class="rounded-circle me-3"
                        src="/images/mary50x50.png"
                        alt="..."
                      />
                      <div class="small">
                        <div class="fw-bold">Moira C.</div>
                        <div class="text-muted">
                          NOV 23, 2022 &middot; 4 min read
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-lg-4 mb-5">
              <div class="card h-100 shadow border-0">
                <img
                  class="card-img-top"
                  src="/images/attic_the_cost_of_inflation900x400.png"
                  alt="..."
                />
               <div class="card-body p-4">
                  <div class="badge-gold">
                     <i class="bi bi-book-half me-1"></i>
                    Product Guide
                  </div>
                  <a
                    class="text-decoration-none link-dark stretched-link"
                    href="attic_the_cost_of_inflation.cfm"
                    ><h5 class="card-title mb-3">
                      The Cost of Inflation: How Capital Gains Taxes and Zonal Repricing Influence Economic Pressures
                    </h5></a
                  >
                  <p class="card-text mb-0">
                    Explore how capital gains taxes and zonal repricing policies unintentionally fuel inflation and widen economic inequality. Government revenue, can drive up asset prices, discourage reinvestment, and increase living costs.
                  </p>
                </div>
                <div class="card-footer p-4 pt-0 bg-transparent border-top-0">
                  <div class="d-flex align-items-end justify-content-between">
                    <div class="d-flex align-items-center">
                      <img
                        class="rounded-circle me-3"
                        src="/images/mira50x50.png"
                        alt="..."
                      />
                      <div class="small">
                        <div class="fw-bold">Mira Y.</div>
                        <div class="text-muted">
                          April 2, 2022 &middot; 10 min read
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>
<!---
############
Footer
############
--->   
 <cfinclude template = "inc_footer.cfm">