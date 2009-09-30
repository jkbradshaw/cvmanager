class ChangeCategoryName < ActiveRecord::Migration
  def self.up
    rename_column :cme_categories, :name, :category
  end

  def self.down
    rename_column :cme_categories, :category, :name
  end
end
