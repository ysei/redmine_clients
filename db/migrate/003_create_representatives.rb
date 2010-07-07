class CreateRepresentatives < ActiveRecord::Migration
  def self.up
    create_table :representatives do |t|
      t.string :name, :null => false, :default => ""
      t.string :post
      t.string :phone
      t.string :mobile_phone
      t.string :email
      t.string :mobile_email
      t.text :note
      t.references :client
    end

    add_index :representatives, :client_id
  end

  def self.down
    drop_table :representatives
  end
end
