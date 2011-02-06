class AddRegistrationTable < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.string :title
      t.string :firstname
      t.string :lastname
      t.string :organization
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :email
      t.string :status
      t.string :dept
      t.integer :eveningsession, :limit => 1
      t.integer :guest, :limit => 1
      t.integer :partysize
      t.integer :lunch, :limit => 1
      t.string :bizperson
      t.string :bizpersonemail
      t.string :bizpersonphone
      t.float :fees
      
      t.timestamps
    end
  end

  def self.down
    drop_table :registrations
  end
end
