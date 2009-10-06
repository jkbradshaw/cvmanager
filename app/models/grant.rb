class Grant < ActiveRecord::Base
  belongs_to :cv
  
  attr_reader :status_codes
  
  @@status_codes = %w[active pending completed]
 
  def status
    @@status_codes[status_id]
  end

  
end
