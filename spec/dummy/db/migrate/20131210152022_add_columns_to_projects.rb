class AddColumnsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :sticky, :boolean
  end
end
