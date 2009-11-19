class Cme < ActiveRecord::Base
  belongs_to :user
  belongs_to :cme_category
  
  accepts_nested_attributes_for :cme_category
  
  delegate :category, :to=>:cme_category
end
