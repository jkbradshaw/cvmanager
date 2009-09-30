class AddColumnsFaculty < ActiveRecord::Migration
  def self.up
    remove_column :faculty, :public_cv
    remove_column :faculty, :rank_id
    add_column :faculty, :user_id, :integer
    add_column :faculty, :leadership, :integer
    add_column :faculty, :clinical_rvu, :integer
    add_column :faculty, :medstudent_teaching, :integer
    add_column :faculty, :resident_teaching, :integer
  end

  def self.down
    add_column :faculty, :public_cv, :string
    add_column :faculty, :rank_id, :integer
    remove_column :faculty, :user_id
    remove_column :faculty, :leadership
    remove_column :faculty, :clinical_rvu
    remove_column :faculty, :medstudent_teaching
    remove_column :faculty, :resident_teaching
  end
end
