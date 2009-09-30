class Rank < ActiveRecord::Base
  has_many :faculty, :dependent=>:nullify
end
