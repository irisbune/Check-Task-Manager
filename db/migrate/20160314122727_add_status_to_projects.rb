class AddStatusToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :status, :string, default: "open"
  end
end
