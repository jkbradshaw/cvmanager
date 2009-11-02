class Education < ActiveRecord::Base
  belongs_to :cv
  has_one :institution, :as=>:experience, :dependent=>:destroy
  accepts_nested_attributes_for :institution
  
  validates_presence_of :degree
  validates_presence_of :year

end
