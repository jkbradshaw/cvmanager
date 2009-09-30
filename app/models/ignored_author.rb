class IgnoredAuthor < ActiveRecord::Base
  belongs_to :cv
  belongs_to :author
  delegate :name, :last_name, :first_name, :to=>:author
end
