module PapersHelper

  def hidden_fields_for_paper(paper,context = '',i=0)
      output = ''

      paper.each do |key, value|
        output << if value.class == Array
          suboutput = ''
          value.each do |v|
            i = i+1
            subcontext =  "#{key}[#{i}]"
            suboutput << "#{hidden_fields_for_paper(v,subcontext,i )}"
          end
          suboutput
        elsif value.class == Hash
          subcontext = "#{key}"
          "#{hidden_fields_for_paper(value,subcontext)}"            
        else
          name = context + "[#{key}]"
          id = name.gsub(/\]\[/,"_")
          id.gsub!(/\]$/,'')
          id.gsub!(/\[|\]/,'_')
          "<input type=\"hidden\" name=\"#{name}\" id=\"#{id}\"  value=\"#{value}\"/>\n"
        end
      end

      output
    end
    
end
