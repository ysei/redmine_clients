class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :name, :null => false, :default => ""
      t.string :phone
      t.string :fax
      t.string :postal
      t.string :address
      t.text :description
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
    end

    add_index :clients, :parent_id
    add_index :clients, [:lft, :rgt], :unique => true
  end

  def self.down
    drop_table :clients
  end
end
