class Faculty < ActiveRecord::Base

  belongs_to :section
  belongs_to :user
  delegate :cv, :to=>:user
  delegate :name, :last_name, :first_name, :to=>:user

  
  def points
    #for Duke, total of 21 points possible
    #clinical:    6pts total
    #             4pts for overall rank
    #             2pts for rank in division/section
    #education:   3pts total
    #             2.5pts for resident teaching
    #             0.5pts for medical student teaching
    #academic:    3pts total
    #             papers: 0.3pts for first author, 0.2pts if a MS or resident is first author and faculty second, 0.1pts otherwise
    #             books/chapters: 0.05pts per chapter
    #admin:       3pts total
    #longevity:   up to 3pts, 0.1pts per year, round partial years up
    #citizenship: 3pts (fudge factor) 
    
    arvu = {}
    
    #clinical
    #@all_faculty = Faculty.find(:all, :order=>'clinical_rvu DESC')
    #@section = section.faculty.find(:all, :order=>'clinical_rvu DESC')
    arvu[:clinical] = 0
    
    #education
    arvu[:res_education]
    #academic
    
    #admin
    arvu[:admin] = admin
    
    #longevity
    
    #citizenship
    arvu[:citizenship] = citizenship

    arvu
  end
  
  def academic_points
    start_date = Date.civil(Time.now.year,1,1)
    papers1 = cv.first_authorship(start_date).count * 0.3
    papers2 = cv.second_authorship_with_trainee(start_date).count * 0.3
    papers3 = 
  end
  
  def clinical_points
  end
  
  def res_education_points
  end
  
  def ms_education_points
  end
  
  def admin_points
    admin
  end
  
  def longevity_points
  end
  
  def citizenship_points
  end
  
  
end
