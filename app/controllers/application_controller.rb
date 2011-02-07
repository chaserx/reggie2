class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def toggle_registration_availability
    case Settings.allow_registration
    when false
      Settings.allow_registration = true
    when true
      Settings.allow_registration = false
    end
    respond_to do |format|
      format.js
    end
  end
  
end
