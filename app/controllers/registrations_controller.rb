class RegistrationsController < ApplicationController
  require 'csv'
  #require 'zip/zip'
  #require 'zip/zipfilesystem'
  require 'zipruby'
  
  before_filter :logged_in?, :except => [:show, :new, :create]
  
  before_filter :registration_open?, :only => :new
  
  def index
    @registrations = Registration.all
    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.xml  { render :xml => @registrations }
      format.csv {
            registrations = Registration.find(:all, :order => "lastname ASC")
            csv = CSV.generate do |csv|
              csv << ["Name", "Dept.", "Org.", "Address1", "Address2", "City", "State", "Zip", "Phone", "email", "Lunch", "EveningSession", "Partysize", "Fees", "BusinessOfficer", "BizOfficerEmail", "BizOfficerPhone", "Date Registered"]
              registrations.each do |registration|
                csv << [[registration.title, registration.firstname, registration.lastname].join(" ").strip, registration.dept, registration.organization, registration.address1, registration.address2, registration.city, registration.state, registration.zip, registration.phone, registration.email, registration.lunch, registration.eveningsession, registration.partysize, registration.fees, registration.bizperson, registration.bizpersonemail, registration.bizpersonphone, registration.created_at ]
              end
            end
            t = Time.now
            send_data(csv, :filename => "Registrations#{t.strftime("%m_%d_%Y")}.csv", 
                      :type => 'text/csv', :disposition => 'attachment')
      }
      format.zip {
                     #registrations_with_attachments = Registration.find_by_sql('SELECT * FROM registrations WHERE abstract_file_name NOT LIKE ""')
                     registrations_with_attachments = Registration.find(:all, :conditions => "abstract_file_name IS NOT NULL")
                     
                     if registrations_with_attachments.size > 0
                       
                       headers['Cache-Control'] = 'no-cache'  
                       tmp_filename = "#{Rails.root.to_s}/tmp/tmp_zip_" <<
                                     Time.now.to_f.to_s <<
                                     ".zip"

                       # zipruby gem
                       Zip::Archive.open(tmp_filename, Zip::CREATE) do |zip|
                       #get all of the attachments

                       # attempt to get files stored on S3
                       # apparently works thanks to Vlad Romascanu;       
                       # http://stackoverflow.com/questions/2338758/zip-up-all-paperclip-attachments-stored-on-s3
                          registrations_with_attachments.each { |e| zip.add_file("abstracts/#{e.abstract.original_filename}", e.abstract.to_file.path) }
                       # => No such file or directory - http://s3.amazonaws.com/bucket/original/abstract.txt
                       # Should note that these files in S3 bucket are publicly accessible. No ACL. 

                       # works with local storage. Thanks to Henrik Nyh
                       # registrations_with_attachments.each { |e| zip.add("abstracts/#{e.abstract.original_filename}", e.abstract.path(:original))   }
                       end

                       send_data(File.open(tmp_filename, "rb+").read, :type => 'application/zip', :disposition => 'attachment', :filename => tmp_filename.to_s)
                       File.delete tmp_filename
                       
                    else
                        redirect_to registrations_path, :notice => "No attachments to zip up"
                    end
               }
    #respond_to end
    end
  # def index end  
  end
  
  def show
    @registration = Registration.find(params[:id])
  end
  
  def new
    @registration = Registration.new
  end
  
  def create
    @registration = Registration.new(params[:registration])
    #if verify_recaptcha(:private_key => PASSWORDS_CONFIG[:recaptcha_private_key]) and @registration.save
    if @registration.save
      flash[:notice] = "Successfully created registration."
      RegistrationMailer.registration_confirmation(@registration).deliver
      redirect_to @registration
    else
      render :action => 'new'
    end
  end
  
  def edit
    @registration = Registration.find(params[:id])
  end
  
  def update
    @registration = Registration.find(params[:id])
    if @registration.update_attributes(params[:registration])
      flash[:notice] = "Successfully updated registration."
      redirect_to @registration
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @registration = Registration.find(params[:id])
    @registration.abstract.clear
    @registration.destroy
    flash[:notice] = "Successfully destroyed registration."
    redirect_to registrations_path
  end
  
  def toggle_registration_availability
    @setting = Settings.first
    case @setting.allow_registration
    when false
      @setting.allow_registration = TRUE
    when true
      @setting.allow_registration = FALSE
    end
    
    if @setting.save
      # it's not ajax, but it works. humph.
      redirect_to registrations_path
    end
  end
  
  protected
  
  def registration_open?
    #redirect_to :action => 'new' and return false unless Settings.allow_registrations
    
    if Settings.first.allow_registration
      return false
    else
      flash[:error] = "Sorry, symposium registration is closed."
      redirect_to root_url
    end
  end

end
