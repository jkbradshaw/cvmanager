

class ArvuController < ApplicationController
  before_filter :set_context
  
  def show
    @faculty_count = Faculty.count
    @section_count = Faculty.section_id_is(@faculty.section.id).count
    @year = Time.now.year
    @all_clinical_points = @faculty.all_clinical_points
    @section_clinical_points = @faculty.section_clinical_points
    @academic_points = @faculty.academic_points
    @res_education_points = @faculty.res_education_points
    @ms_education_points = @faculty.ms_education_points
    @admin_points = @faculty.admin_points
    @longevity_points = @faculty.longevity_points
    @citizenship_points = @faculty.citizenship_points
    @total_points = @all_clinical_points + @section_clinical_points + @academic_points + @res_education_points + @ms_education_points + @admin_points + @longevity_points + @citizenship_points
    
    
    pc = GoogleChart::PieChart.new('600x400', "Academic RVU Breakdown",false)
    pc.data 'Clinical', @all_clinical_points + @section_clinical_points
    pc.data 'Education', @res_education_points + @ms_education_points
    pc.data 'Academic', @academic_points
    pc.data 'Other', @admin_points + @citizenship_points + @longevity_points
    @chart_url = pc.to_url

    #@chart_url = GoogleChart.pie(['Clinical',@all_clinical_points + @section_clinical_points], ['Education', @res_education_points + @ms_education_points], ['Academic', @academic_points], ['Other',@leadership_points + @citizenship_points + @longevity_points])
    # "http://chart.apis.google.com/chart?cht=p3&chd=t:60,40&chs=250x100&chl=Hello|World"
  end
    
  private
    def set_context
      if user_context
        @faculty = user_context.faculty
      else
        flash[:notice] = 'Please log in'
        redirect_to root_url
      end
    end
    
end
  
    