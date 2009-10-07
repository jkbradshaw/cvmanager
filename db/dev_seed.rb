#use in the console to add some test data: require 'db/dev_seed'

require 'rubygems'
require 'faker'
require 'machinist'
require 'sham'
require 'machinist'
require 'test/blueprints'

4.times do
  section = Section.make

  10.times do
    u = User.make
    f = Faculty.make(:user=>u, :section=>section)
    cv = u.cv
  
    Address.make(:cv=>cv)
    3.times do
      Education.make(:cv=>cv)
    end
    3.times do
      Training.make(:cv=>cv)
    end
    3.times do
      Employment.make(:cv=>cv)

    end
    2.times do
      Certification.make(:cv=>cv)
    end
    4.times do
      Award.make(:cv=>cv)
    end
    2.times do
      Patent.make(:cv=>cv)
    end
    Grant.make(:cv=>cv)
  
    a = Author.make(:last_name => f.last_name, :first_name => f.first_name, :cv=>cv)
    b = Author.make
    c = Author.make
    d = Author.make
    e = Author.make(:trainee=>true)
  
    10.times do
      p = Paper.make
      p.authorships.create({:author=>a, :author_position=>1})
      p.authorships.create({:author=>b, :author_position=>2})
    end
    10.times do
      p = Paper.make(:current)
      p.authorships.create({:author=>a, :author_position=>1})
      p.authorships.create({:author=>c, :author_position=>2})
      p.authorships.create({:author=>d, :author_position=>3})
    end
    4.times do
      p = Paper.make(:current)
      p.authorships.create({:author=>e, :author_position=>1})
      p.authorships.create({:author=>a, :author_position=>2})
      p.authorships.create({:author=>d, :author_position=>3})
    end
    10.times do
      p = Paper.make(:current)
      p.authorships.create({:author=>b, :author_position=>1})
      p.authorships.create({:author=>c, :author_position=>2})
      p.authorships.create({:author=>a, :author_position=>3})
    end
  
    5.times do
      book = Book.make(:current_chapter)
      book.authorships.create({:author=>a, :author_position=>1})
      book.authorships.create({:author=>b, :author_position=>2})
    end
  
    10.times do
      p = Presentation.make
      p.authorships.create({:author=>e, :author_position=>1})
      p.authorships.create({:author=>a, :author_position=>2})
      p.authorships.create({:author=>d, :author_position=>3})
    end
  end
end
