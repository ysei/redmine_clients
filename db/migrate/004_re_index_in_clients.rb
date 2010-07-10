class ReIndexInClients < ActiveRecord::Migration
  def self.up
    remove_index :clients, [:lft, :rgt]
    add_index :clients, [:lft, :rgt]
  end

  def self.down
    remove_index :clients, [:lft, :rgt]
    add_index :clients, [:lft, :rgt], :unique => true
  end
end
