class NormalizeNames < ActiveRecord::Observer

  observe Author, User
  
  def before_save(model)
    [:last_name, :first_name].each do |field|
      model[field].gsub!(/\./,'')
      names = model[field].split(' ')
      names.map!{ |x| x.capitalize }
      model[field] = names.join(' ')
    end
  end
  
  #def before_save(model)
  #  [:last_name, :first_name].each do |field|
  #    model[field].upcase!
  #    model[field].gsub!(/\./,'')
  #  end
  #end
  
  #def after_save(model)
  #  [:last_name, :first_name].each do |field|
  #    model[field].downcase!
  #    words = model[field].split(' ')
  #    words.map!{|x| x.capitalize}
  #    model[field] =  words.join(' ')
  #  end
  #end
  
  #alias_method :after_find, :after_save
end

