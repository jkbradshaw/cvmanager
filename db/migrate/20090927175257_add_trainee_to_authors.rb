class AddTraineeToAuthors < ActiveRecord::Migration
  def self.up
    add_column :authors, :trainee, :boolean, :default=>false
  end

  def self.down
    remove_column :authors, :trainee
  end
end
