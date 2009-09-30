class Education < ActiveRecord::Base
  belongs_to :cv
  has_one :institution, :as=>:experience, :dependent=>:destroy
  accepts_nested_attributes_for :institution
end
