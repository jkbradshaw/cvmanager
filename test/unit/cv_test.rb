require 'test_helper'

class CvTest < ActiveSupport::TestCase

  should_have_many :authors
  should_have_many :ignored_authors
  should_have_many :education
  should_have_many :awards
  should_have_many :memberships
  should_have_many :certifications
  should_have_many :employment
  should_have_many :training
  should_have_one :address
  should_belong_to :user
  
  context "A cv instance" do
    setup do
      @cv = Cv.make
      @other_cv = Cv.make
    end
    
    #test possible_authors  
    context "trying to match possible authors" do
      setup do
        @lnfi = Author.make(:last_name=>@cv.last_name)
        @lnfi.first_name[0] = @cv.first_name[0]
        @lnfi.save
        
        @wrong_lastname = Author.make(:last_name=>@cv.last_name.reverse)
        
        @already_assigned_someone_else = Author.make(:last_name=>@cv.last_name, :cv=>@other_cv)
        @already_assigned_someone_else.first_name[0] = @cv.first_name[0]
        @already_assigned_someone_else.save
        
        @assigned_to_self = Author.make(:last_name=>@cv.last_name, :first_name=>@cv.first_name, :cv=>@cv)
        
        @ignored = Author.make
        @cv.ignore_authors(@ignored)

        @possible_authors = @cv.possible_authors
      end
      
      should "find authors that share last name and first initial" do
        assert @possible_authors.include?(@lnfi)
      end
      
      should "not find authors with a different last name" do
        assert ! @possible_authors.include?(@wrong_lastname)
      end
      
      should "not find authors assigned to someone else" do
        assert ! @possible_authors.include?(@already_assigned_someone_else)
      end
      
      should "not find authors already assigned to self" do
        assert ! @possible_authors.include?(@assigned_to_self)
      end
      
      should "not find ignored authors" do
        assert ! @possible_authors.include?(@ignored)
      end
    end

    
    #test find_publication_author
    context "with a paper" do
      setup { @paper = Paper.make }
      
      context "with an author that shares last name and first initial" do
        setup do
          @cv.authors.destroy
          @author = Author.make(:last_name=>@cv.last_name)
          @author.first_name[0] = @cv.first_name[0]
          @author.save
          @paper.authors << @author
        end
        
        should "find name on paper" do
          assert @cv.find_publication_author(@paper)
        end
        
        should "add author when the paper is added" do
          @cv.add_publication(@paper)
          assert @cv.authors.include?(@author)
        end 
      end    
    end
    
    context "with a paper and cv author as first author" do
      setup do
        @author_a = Author.make(:cv=>@cv)
        @paper = Paper.make
        @paper.authorships.create({:author=>@author_a, :author_position=>1})
      end
      should "include that paper when asked for first author papers" do
        assert @cv.first_authorship_papers.include?(@paper)
      end
      
    end
    
    context "with a paper, trainee author as first, cv author as second" do
      setup do
        @trainee_author = Author.make(:trainee=>true)
        @author = Author.make(:cv=>@cv)
        @paper = Paper.make
        @paper.authorships.create({:author=>@trainee_author, :author_position=>1})
        @paper.authorships.create({:author=>@author, :author_position=>2})
      end
      should "include that paper when asked for trainee papers" do
        assert @cv.second_authorship_papers_with_trainee.include?(@paper)
      end
    end
  end
end
