class RegistrationMailer < ActionMailer::Base
  
  def registration_confirmation(registration)
      @registration = registration
      @admin_email = APP_CONFIG['admin_email'].to_s
      mail(:from => "no-reply@registrationapp.com", :to => "#{registration.firstname} #{registration.lastname} <#{registration.email}>", :subject => "You've been registered")
  end
end
