class RegistrationMailer < ActionMailer::Base
  default :from => "no-reply@registrationapp.com"
  
  def registration_confirmation(registration)
      mail(:to => "#{registration.firstname registration.lastname} <#{registration.email}>", :subject => "You've been registered")
  end
end
