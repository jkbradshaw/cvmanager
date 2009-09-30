class Institution < ActiveRecord::Base
  belongs_to :experience, :polymorphic=>true
end
