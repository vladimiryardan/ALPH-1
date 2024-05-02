 <cfinclude template = "inc_header.cfm">
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
      Contact Form
      ############
      -->
      <section class="py-5" id="Contact">
        <div class="container">
          <h2 class="text-center">Contact Us</h2>
          <div class="row justify-content-center">
            <div class="col-md-8">
              <form id="contactForm">
                <div class="form-group">
                  <label for="name">Name:</label>
                  <input type="text" class="form-control" id="name" placeholder="Enter your name" required>
                </div>
                <div class="form-group">
                  <label for="email">Email:</label>
                  <input type="email" class="form-control" id="email" placeholder="Enter your email" required>
                </div>
                <div class="form-group">
                  <label for="message">Message:</label>
                  <textarea class="form-control" id="message" rows="5" placeholder="Enter your message" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Submit</button>
              </form>
              <div id="successMessage" style="display: none; margin-top: 20px;" class="alert alert-success text-center">Thank you for your message!</div>
            </div>
          </div>
        </div>
        
        <script>
          $(document).ready(function(){
            $('#contactForm').submit(function(e){
              e.preventDefault(); // Prevent form submission
        
              // Get form values
              var name = $('#name').val();
              var email = $('#email').val();
              var message = $('#message').val();
        
              // You can perform validation here if needed
        
              // AJAX request to send form data to server
              $.ajax({
                url: 'process_contact.php', // Update with your server-side script URL
                type: 'POST',
                data: {
                  name: name,
                  email: email,
                  message: message
                },
                success: function(response){
                  // Show success message and clear form
                  $('#successMessage').show();
                  $('#contactForm')[0].reset();
                },
                error: function(xhr, status, error){
                  // Show error message if request fails
                  alert('An error occurred while submitting the form: ' + error);
                }
              });
            });
          });
        </script>
      </section>

     
    </main>
 <cfinclude template = "inc_footer.cfm">