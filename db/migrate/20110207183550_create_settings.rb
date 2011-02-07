class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.boolean :allow_registration, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
