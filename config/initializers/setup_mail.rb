if Rails.env.development?
  ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => "587",            
    :domain               => PASSWORDS_CONFIG[:domain],
    :user_name            => PASSWORDS_CONFIG[:mailuser],
    :password             => PASSWORDS_CONFIG[:mailpass],
    :authentication       => "plain",        
    :enable_starttls_auto => true
  }
else
  ActionMailer::Base.smtp_settings = {
    :address        => "smtp.sendgrid.net",
    :port           => "25",
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => ENV['SENDGRID_DOMAIN']
  }
end

ActionMailer::Base.default_url_options[:host] = "localhost:3000"