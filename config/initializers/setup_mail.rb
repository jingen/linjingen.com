ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "urappzone.com",
    :user_name            => "urappzone@gmail.com",
    :password             => "83681600lje.",
    :authentication       => "plain",
    :enable_starttls_auto => true
  }