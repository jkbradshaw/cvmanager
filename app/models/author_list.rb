module Author_list
  def author_list=(auths)
    auths_array = []
    x = 0
    auths.split(',').each do |a|
      x = x + 1
      b = a.scan(/\w+/)
      l = b.pop
      f = b.join(' ')
      auths_array << {:last_name => l, :first_name => f, :author_position => x}
    end
    
    self.authorships.destroy_all unless self.new_record?
    auths_array.each do |a|
      self.authorships.build({:author=>Author.find_or_create_by_first_and_last_name(a), :author_position=> a[:author_position].to_i})
    end
  end
  
  def author_list
    auths_array = []
    authorships.each do |a|
      auths_array << a.author.name
    end
    auths_array.join(', ')
  end
end