ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => CONFIG[:domain],
    :user_name            => CONFIG[:gmail],
    :password             => CONFIG[:gmail_password],
    :authentication       => "plain",
    :enable_starttls_auto => true
  }