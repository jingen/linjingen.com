ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "linjingen.com",
    :user_name            => "jelinmscs@gmail.com",
    :password             => "83681600lje.",
    :authentication       => "plain",
    :enable_starttls_auto => true
  }