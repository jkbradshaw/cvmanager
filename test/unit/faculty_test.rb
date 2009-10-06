require 'test_helper'

class FacultyTest < ActiveSupport::TestCase
    
  should_belong_to :section
  should_belong_to :user
  should_delegate :cv, :to=>:user
  should_delegate :name, :last_name, :first_name, :to=>:user

  context "faculty member" do
    setup do
      @user = User.make
      @cv = @user.cv
      @faculty = Faculty.make(:user=>@user)
      
      @author = Author.make(:cv=>@cv)
      @trainee_author = Author.make(:trainee=>true)
      @other_author = Author.make
      @another_author = Author.make

    end
    
    context "with first author paper in the database" do
      setup do
        @first_author = Paper.make(:current)
        @first_author.authorships.create({:author=>@author,:author_position=>1})
        @first_author.authorships.create({:author=>@other_author, :author_position=>2})
      end
      should "report 0.3 academic points" do
        assert @faculty.academic_points == 0.3
      end
    end
    
    context "with trainee first author, self as second author paper" do
      setup do
        @trainee_paper = Paper.make(:current)
        @trainee_paper.authorships.create({:author=>@trainee_author, :author_position=>1})
        @trainee_paper.authorships.create({:author=>@author, :author_position=>2})
      end
      should "report 0.2 academic points" do
        assert @faculty.academic_points == 0.2
      end
    end
    
    context "with paper as third author" do
      setup do
        @third_author = Paper.make(:current)
        @third_author.authorships.create({:author=>@other_author, :author_position=>1})
        @third_author.authorships.create({:author=>@another_author, :author_position=>2})
        @third_author.authorships.create({:author=>@author, :author_position=>3})
      end
      should "report 0.1 academic points" do
        assert @faculty.academic_points == 0.1
      end
    end
    
    context "with old paper in the database" do
      setup do
        @old_paper = Paper.make #should be old -- sham date is before 2006
        @old_paper.authorships.create({:author=>@author, :author_position=>1})
      end
      should "report 0 academic points" do
        assert @faculty.academic_points == 0
      end
    end
    
    context "with book in the database" do
      setup do
        @book = Book.make(:current_book)
        @book.authorships.create({:author=>@author, :author_position=>1})
      end
      should "report 0.05 academic points" do
        assert @faculty.academic_points == 0.05
      end
    end
    
    context "with book chapter in the database" do
      setup do
        @chapter = Book.make(:current_chapter)
        @chapter.authorships.create({:author=>@author, :author_position=>1})
      end
      should "report 0.05 academic points" do
        assert @faculty.academic_points == 0.05
      end
    end
      
    context "with 11 first author papers" do
      setup do
        (1..11).each do |i|
          p = Paper.make(:current)
          p.authorships.create({:author=>@author, :author_position=>1})
        end
      end
      should "not report more than 3pts" do
        assert @faculty.academic_points < 3.01
      end
    end

    #TODO: tests for res_education_points
    
    
    context "in the top half for ms education" do
      setup do
        10.times {Faculty.make}
        @faculty.medstudent_teaching = 9
      end
      should "report 0.5 ms education points" do
        assert @faculty.ms_education_points == 0.5
      end
      
    end
  
    context "in the bottom half for ms education" do
      setup do
        10.times {Faculty.make}
        @faculty.medstudent_teaching = 1
      end
      should "report 0 ms education points" do
        assert @faculty.ms_education_points == 0
      end
    end
    
    context "with start date in 2005" do
      setup do
        @expected_longevity_points =( ((Date.civil(Time.now.year,12,31) - Date.civil(2005,6,1)).to_f/365)+0.9 ).to_i * 0.1
        @faculty.start_date = Date.civil(2005,6,1)
        @faculty.save
      end
      should "report expected longevity points (0.1 per year, partial year is full 0.1 points)" do
        assert @faculty.longevity_points == @expected_longevity_points
      end
    end
    
  end
  
end
