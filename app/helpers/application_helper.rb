# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def html_authors_for(paper,faculty)
    cv_authors = faculty ? faculty.authors : []
    output =  []
    authorships = paper.authorships.sort {|x,y| x.author_position <=> y.author_position}
    authors = authorships.collect{|x| Author.find(x.author_id)}
    authors.each do |p| 
      if cv_authors.include?(p)
        output << '<strong>' + p.first_name + ' ' + p.last_name + '</strong>'
      else
        output << p.first_name + ' ' + p.last_name
      end
    end
    output.join(', ')
  end
  
  def html_pubmed_authors_for(pubmed_authors)
    output = []
    pubmed_authors.sort {|x,y| x[:author_position] <=> y[:author_position]}
    pubmed_authors.each do |a|
      output << "#{a[:first_name]} #{a[:last_name]}"
    end
    output.join(', ')
  end 
  
  def navigation_link(link,path,active=false)
    li_class = active ? " class='ui-state-active ui-widget'" : " class='ui-state-default'"
    "<li#{li_class}>#{link_to link, path}</li>"
  end
  
  def tab_to(link,path,active=false)
    li_class = active ? "active ui-corner-top" : "ui-corner-top"
    "<li class='#{li_class}'>#{link_to link, path}</li>"
  end
  
  def method_missing(name, *args)
    if x = name.to_s.match(/(.+)_fg_button_to/)
      icon = x[1].split('_')
      if icon.count > 1
        side = icon.pop if %w[right left solo].include?(icon.last)
      else
        side = 'left'
      end
      icon = icon.join('-')
      self.send :fg_button_to, icon, side, *args  
    elsif x = name.to_s.match(/(.+)_icon_to/)
      icon = x[1].gsub('/_/','-')
      self.send :fg_button_to, icon, 'solo', *args
    else
      super
    end
  end
  
  def fg_submit_button(msg, options = {})
    id = options[:id] ? "id='#{options[:id]}'" : ""
    "<input type='submit' value='#{msg}' #{id} class='fg-button ui-state-default ui-corner-all' ></input>"
  end
  
  def fg_cancel_button(msg, options = {})
    "<input type='submit' value='#{msg}' name='cancel' class='fg-button ui-state-default ui-corner-all' ></input>"
  end
  
  def flash_div(flash_hash)
    output = ''
    flash_class = flash_icon = {}
    flash_class[:error] = 'error'
    flash_class[:notice] = 'highlight'
    flash_icon[:error] = 'alert'
    flash_icon[:notice] = 'info'
    flash_hash.each do |name,msg|
      output << "<div class='ui-widget'><div class='ui-state-#{flash_class[name.to_sym]} ui-corner-all' style='padding: 0pt 0.7em;'><p><span class='ui-icon ui-icon-#{flash_icon[name.to_sym]}' style='float:left; margin-right: 0.3em' />#{msg}</p></div></div>"
    end
    output
  end
  
  def one_line_address(address)
    output = ''
    a = []
    %w[address1 address2 address3 city state].each do |x|
      a << address.send(x) unless address.send(x).empty?
    end
    output << a.join(' . ')
  end
  
  private
    def fg_button_to(icon, side, name, options = {}, html_options = {})
      html_options[:title] = name
      name = "<span class='ui-icon ui-icon-#{icon}'></span>" + name
      html_options[:class] ||= ''
      html_options[:class] = html_options[:class] + " fg-button fg-button-icon-#{side} ui-state-default ui-corner-all"
      link_to name, options, html_options
    end

  
end
