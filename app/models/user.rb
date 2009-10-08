class User < ActiveRecord::Base

  acts_as_authentic
  acts_as_authorization_subject
  
  attr_accessor :password
  
  has_one :cv, :dependent=>:destroy
  has_many :cmes, :dependent=>:destroy
  has_one :faculty, :dependent=>:destroy
  
  before_create :start_cv
  
  @@site_permissions = [:admin] #this is not the best place for this -- I need to find a better spot
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def update_permissions(params)
    params = params.collect {|key,value| key.to_sym}
    set_roles = params & @@site_permissions
    remove_roles = @@site_permissions - params
    set_roles.each do |r|
      self.has_role!(r)
    end
    remove_roles.each do |r|
      self.has_no_role!(r)
    end
  end
  
  def managed
    search = roles.name_is('manager').authorizable_type_is('Cv').all
    managed_users = search.collect {|x| Cv.find(x.authorizable_id).user if Cv.exists?(x.authorizable_id)}
    managed_users
  end
  
  def self.site_permissions
    @@site_permissions
  end
  
  private
    def start_cv
      self.build_cv unless self.cv
    end

  
end
