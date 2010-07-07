class CreateClientProjects < ActiveRecord::Migration
  def self.up
    create_table :client_projects do |t|
      t.references :client
      t.references :project
    end
    add_index :client_projects, [:client_id, :project_id]
  end

  def self.down
    drop_table :client_projects
  end
end
