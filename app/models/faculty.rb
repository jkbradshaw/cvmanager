class Faculty < ActiveRecord::Base

  belongs_to :section
  belongs_to :user
  delegate :cv, :to=>:user
  delegate :name, :last_name, :first_name, :to=>:user
  delegate :presentations, :chapters, :books, :papers, :books_and_chapters, :to=>:cv

  
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
    
    #add up points from other methods
  end
  
  def academic_points
    start_date = Date.civil(Time.now.year,1,1)
    all_papers = cv.papers(Time.now.year)
    papers1 = cv.first_authorship_papers(start_date)
    papers2 = cv.second_authorship_papers_with_trainee(start_date)
    papers_other = all_papers - papers1 - papers2
    
    books = cv.books_and_chapters(Time.now.year)
    
    points = (papers1.count * 0.3) +  (papers2.count * 0.2) + (papers_other.count * 0.1) + (books.count * 0.05)
    points = 3 if points > 3
    points
  end
  
  def all_clinical_points
    all_faculty = Faculty.ascend_by_clinical_rvu.all
    count = all_faculty.count
    points = 4
    [0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1].each do |q|
      points = q * 4 if clinical_rvu <= all_faculty[(count*q + 0.5).to_i].clinical_rvu
    end
    points
  end
  
  def section_clinical_points
    section_faculty = Faculty.section_id_is(self.section_id).ascend_by_clinical_rvu.all
    count = section_faculty.count
    points = 2
    if count > 1
      [0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1].each do |q|
        points = q * 2 if clinical_rvu <= section_faculty[(count*q + 0.5).to_i].clinical_rvu
      end
    end
    points
  end
  
  def res_education_points
    all_faculty = Faculty.ascend_by_resident_teaching.all
    count = all_faculty.count
    re_points = 2.5
    [0.9,0.8,0.7, 0.6,0.5, 0.4,0.3, 0.2,0.1].each do |q|
      re_points = q * 2.5 if resident_teaching <= all_faculty[(count*q + 0.5).to_i].resident_teaching
    end
    re_points
  end
  
  def ms_education_points
    all_faculty = Faculty.ascend_by_medstudent_teaching.all
    median = all_faculty[all_faculty.count/2].medstudent_teaching
    if medstudent_teaching >= median
      0.5
    else
      0.0
    end
  end
  
  def admin_points
    if leadership > 3
      3
    else
      leadership
    end    
  end
  
  def longevity_points
    points = ( ( (Date.civil(Time.now.year,12,31) - start_date).to_f/365 ) + 0.9 ).to_i * 0.1
    points = 3 if points > 3
    points
  end
  
  def citizenship_points
    if citizenship > 3
      3
    else
      citizenship
    end
  end
  
  
end
