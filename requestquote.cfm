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
      Contact Form
      ############
      -->
      <section class="py-5" id="Contact">
        <div class="container">
          <h2 class="text-center">Contact Us</h2>
         
          <div class="row justify-content-center">
            
            <div class="col-md-8 ">
              <p class="text-center tracking-wide">If you have inquiries about our products or services at Attic Ladder PH, don't hesitate to contact us. 
                We're here to help!
              </p>
              <form id="contactForm">
                <div class="form-group pb-3">
                  <label for="name">Name:</label>
                  <input type="text" class="form-control" id="name" placeholder="Enter your name" required>
                </div>
                <div class="form-group pb-3">
                  <label for="name">Company:</label>
                  <input type="text" class="form-control" id="company" placeholder="Enter Company Name" >
                </div>                
                <div class="form-group pb-3">
                  <label for="email">Email:</label>
                  <input type="email" class="form-control" id="email" placeholder="Enter your email" required>
                </div>
                <div class="form-group pb-3">
                  <label for="message">Message:</label>
                  <textarea class="form-control" id="message" rows="5" placeholder="Enter your message" required></textarea>
                </div>
                <!-- ColdFusion CAPTCHA -->
                <div class="form-group">
                  <!--- <img src="generate_captcha.cfm" alt="CAPTCHA Image"> --->
                  <iframe id="frameCaptcha" src="generate_captcha.cfm" width="300" height="100" scrolling="no" frameborder="0" style="overflow:auto;"></iframe>
                  <input type="text" class="form-control" id="captcha" name="captcha" placeholder="Enter CAPTCHA" required>
                </div>                
                <button type="submit" class="btn btn-primary btn-block mt-3">Submit</button>
              </form>
              <div id="successMessage" style="display: none; margin-top: 20px;" class="alert alert-success text-center">Thank you for your message!</div>
            </div>
          </div>
        </div>

<script
  src="https://code.jquery.com/jquery-3.7.1.min.js"
  integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
  crossorigin="anonymous"></script> 
          
        <script>
          $(document).ready(function(){
            $('#contactForm').submit(function(e){
              e.preventDefault(); // Prevent form submission
        
              // Get form values
              var name = $('#name').val();
              var email = $('#email').val();
              var message = $('#message').val();
              var canswer = $('#captcha').val();
              
              // You can perform validation here if needed
        
              // AJAX request to send form data to server
              $.ajax({
                url:	'contact.cfc?method=fnContactForm', // Update with your server-side script URL
                type:	'POST',
                cache:	false,
                data: {
                  name: name,
                  email: email,
                  message: message,
                  canswer: canswer,

                },
                success: function(response){

                  $('#frameCaptcha').attr('src', $('#frameCaptcha').attr('src'));  
                  var cleanedResponse = response.trim();
                  if(cleanedResponse == "Success" || cleanedResponse == "1"){
                    $('#successMessage').show();   

                    // Hide it after 5 seconds (5000 milliseconds)
                    setTimeout(function() {
                        $('#successMessage').hide();
                    }, 5000);

                  }else{
                    alert('An error occurred')
                  }
                  
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