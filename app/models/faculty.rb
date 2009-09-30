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
    
    #add up points from other methods
  end
  
  def academic_points
    start_date = Date.civil(Time.now.year,1,1)
    all_papers = cv.papers.pmed_date_greater_than(Date.civil(Time.now.year,1,1)).all
    papers1 = cv.first_authorship_papers(start_date)
    papers2 = cv.second_authorship_papers_with_trainee(start_date)
    papers_other = all_papers - papers1 - papers2
    
    books = cv.books_and_chapters(Time.now.year)
    
    (papers1.count * 0.3) +  (papers2.count * 0.2) + (papers_other.count * 0.1) + (books.count * 0.05)
  end
  
  def clinical_points
    0
  end
  
  def res_education_points
    0
  end
  
  def ms_education_points
    0
  end
  
  def admin_points
    leadership
  end
  
  def longevity_points
    0
  end
  
  def citizenship_points
    citizenship
  end
  
  
end
