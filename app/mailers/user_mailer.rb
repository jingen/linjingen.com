class UserMailer < ActionMailer::Base
  default :from => "urappzone@gmail.com"

  def registration_confirmation(email)
    @email = email
    mail(:to => "user name <#{email}>", :subject => "Registered")
  end

  def send_message_to_lje(contact)
    @contact = contact
    lje_email = "jingen.lin.jl@gmail.com"
    mail(:to => "Jingen Lin <#{lje_email}>", :subject => "Message from #{contact[:email]}")
  end
end
