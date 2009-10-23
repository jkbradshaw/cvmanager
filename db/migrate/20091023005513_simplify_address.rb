class SimplifyAddress < ActiveRecord::Migration
  def self.up
    add_column :addresses, :address, :text
    Address.all.each do |a|
      %w[address1 address2 address3].inject('') {|@new_address,@old_attribute| @new_address += a.send(@old_attribute) + "\n" if a.send(@old_attribute)}
      @new_city = "#{a.city}, #{a.state}  #{a.zip} \n #{a.country}"  
      a.address = @new_address + @new_city
      a.save
    end
    remove_column :addresses, :address1
    remove_column :addresses, :address2
    remove_column :addresses, :address3
    remove_column :addresses, :city
    remove_column :addresses, :state
    remove_column :addresses, :zip
    remove_column :addresses, :country
  end

  def self.down
    remove_column :addresses, :address
    add_column :addresses, :address1, :string
    add_column :addresses, :address2, :string
    add_column :addresses, :address3, :string
    add_column :addresses, :city, :string
    add_column :addresses, :state, :string
    add_column :addresses, :zip, :string
    add_column :addresses, :country, :string
  end
end
