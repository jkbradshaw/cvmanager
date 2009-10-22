class AddCvIdToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :cv_id, :integer
  end

  def self.down
    remove_column :activities, :cv_id
  end
end
