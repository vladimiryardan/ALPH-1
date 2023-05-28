 <cfinclude template = "inc_header.cfm">
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
      <header class="bg-dark py-5">
        <div class="container px-5">
          <div class="row gx-5 align-items-center justify-content-center">
            <div class="col-lg-8 col-xl-7 col-xxl-6">
              <div class="my-5 text-center text-xl-start">
                <h1 class="display-5 fw-bolder text-white mb-2">
                  Attic Ladder
                  <br />Free Space Lifestyle
                </h1>
                <p class="lead fw-normal text-white-50 mb-4">
                  Create more spaces for the family.
                  <br />Build accessible storage and rooms.
                </p>

                <!-- <div class="d-grid gap-3 d-sm-flex justify-content-sm-center justify-content-xl-start">
                                    <a class="btn btn-primary btn-lg px-4 me-sm-3" href="#features">Get Started</a>
                                    <a class="btn btn-outline-light btn-lg px-4" href="#!">Learn More</a>
                                </div> -->
              </div>
            </div>
            <div class="col-xl-5 col-xxl-6 d-none d-xl-block text-center">
              <img
                class="img-fluid rounded-3 my-5"
                src="./images/attic-ladder-viewport.png"
                alt="..."
              />
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
      <div class="py-5 bg-light">
        <div class="container px-5 my-5">
          <div class="row gx-5 justify-content-center">
            <div class="col-lg-10 col-xl-7">
              <div class="text-center">
                <div class="feedback">
                  <i class="bi bi-chat-quote chat-quote-custom"></i>
                  <div class="fs-4 mb-4 fst-italic">
                    It's time to start designing for our Home. Architects and
                    Engineers enables our Living Spaces that fits the purpose,
                    to improve our Quality of Life.
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
                      <span class="fw-bold text-primary mx-1">/</span>
                      Attic Ladder Customer
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
                <h2 class="fw-bolder">From our blog</h2>
                <p class="lead fw-normal text-muted mb-5">
                  Lorem ipsum, dolor sit amet consectetur adipisicing elit.
                  Eaque fugit ratione dicta mollitia. Officiis ad.
                </p>
              </div>
            </div>
          </div>
          <div class="row gx-5">
            <div class="col-lg-4 mb-5">
              <div class="card h-100 shadow border-0">
                <img
                  class="card-img-top"
                  src="./images/600x350_attic_ladder_types2.png"
                  alt="..."
                />
                <div class="card-body p-4">
                  <div class="badge bg-primary bg-gradient rounded-pill mb-2">
                    News
                  </div>
                  <a
                    class="text-decoration-none link-dark stretched-link"
                    href="attic_ladder_types.cfm"
                    ><h5 class="card-title mb-3">Attic Ladders Types</h5></a
                  >
                  <p class="card-text mb-0">
                    Some quick example text to build on the card title and make
                    up the bulk of the card's content.
                  </p>
                </div>
                <div class="card-footer p-4 pt-0 bg-transparent border-top-0">
                  <div class="d-flex align-items-end justify-content-between">
                    <div class="d-flex align-items-center">
                      <img
                        class="rounded-circle me-3"
                        src="https://dummyimage.com/40x40/ced4da/6c757d"
                        alt="..."
                      />
                      <div class="small">
                        <div class="fw-bold">Kelly Rowan</div>
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
                  src="https://dummyimage.com/600x350/adb5bd/495057"
                  alt="..."
                />
                <div class="card-body p-4">
                  <div class="badge bg-primary bg-gradient rounded-pill mb-2">
                    Media
                  </div>
                  <a
                    class="text-decoration-none link-dark stretched-link"
                    href="#!"
                    ><h5 class="card-title mb-3">Another blog post title</h5></a
                  >
                  <p class="card-text mb-0">
                    This text is a bit longer to illustrate the adaptive height
                    of each card. Some quick example text to build on the card
                    title and make up the bulk of the card's content.
                  </p>
                </div>
                <div class="card-footer p-4 pt-0 bg-transparent border-top-0">
                  <div class="d-flex align-items-end justify-content-between">
                    <div class="d-flex align-items-center">
                      <img
                        class="rounded-circle me-3"
                        src="https://dummyimage.com/40x40/ced4da/6c757d"
                        alt="..."
                      />
                      <div class="small">
                        <div class="fw-bold">Josiah Barclay</div>
                        <div class="text-muted">
                          March 23, 2022 &middot; 4 min read
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
                  src="https://dummyimage.com/600x350/6c757d/343a40"
                  alt="..."
                />
                <div class="card-body p-4">
                  <div class="badge bg-primary bg-gradient rounded-pill mb-2">
                    News
                  </div>
                  <a
                    class="text-decoration-none link-dark stretched-link"
                    href="#!"
                    ><h5 class="card-title mb-3">
                      The last blog post title is a little bit longer than the
                      others
                    </h5></a
                  >
                  <p class="card-text mb-0">
                    Some more quick example text to build on the card title and
                    make up the bulk of the card's content.
                  </p>
                </div>
                <div class="card-footer p-4 pt-0 bg-transparent border-top-0">
                  <div class="d-flex align-items-end justify-content-between">
                    <div class="d-flex align-items-center">
                      <img
                        class="rounded-circle me-3"
                        src="https://dummyimage.com/40x40/ced4da/6c757d"
                        alt="..."
                      />
                      <div class="small">
                        <div class="fw-bold">Evelyn Martinez</div>
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