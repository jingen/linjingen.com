class UserMailer < ActionMailer::Base
  # default from => "linjingen.com@gmail.com"
  default :from => "linjingen.com@gmail.com"

  # def registration_confirmation(user)
  #   mail(:to => user.email, :subject => "Registered")
  # end

  def registration_confirmation(email)
    @email = email
    mail(:to => "user name <#{email}>", :subject => "Registered")
  end
end
