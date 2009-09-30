require 'machinist/active_record'
require 'sham'

Sham.define do
  title { Faker::Lorem.words(5).join(' ') }
  level {Faker::Lorem.words(1)}
  specialty {Faker::Lorem.words(2).join(' ')}
  last_name  { Faker::Name.last_name }
  first_name  { Faker::Name.first_name }
  username {Faker::Name.first_name+Faker::Name.last_name}
  per_name {Faker::Name.name}
  nlmuid { (1..10).map { ('0'..'9').to_a.rand } }
  pmid { |x| "1687634#{x}" }
  issn { ((1..4).map {('0'..'9').to_a.rand}).to_s + "-" + ((1..4).map {('0'..'9').to_a.rand}).to_s }
  year { (1950..(Time.now.year)).to_a.rand.to_i }
  pages { (100..150).to_a.rand.to_s + '-' + (151..200).to_a.rand.to_s }
  publisher {Faker::Company.name}
  description {Faker::Lorem.paragraph}
  date { Date.civil( (2000..2006).to_a.rand, (1..12).to_a.rand, (1..30).to_a.rand )  }
  later_date { Date.civil( (2007..2009).to_a.rand, (1..12).to_a.rand, (1..30).to_a.rand )  }
  location {Faker::Address.city}
  email {Faker::Internet.email}
  hours { (1..4).to_a.rand }
end

Address.blueprint do
  address1 {Faker::Company.name}
  address2 {Faker::Address.street_address}
  address3 {Faker::Address.secondary_address}
  city {Faker::Address.city}
  state {Faker::Address.us_state}
  country {'USA'}
  email
  phone {Faker::PhoneNumber.phone_number}
  cv
end

Author.blueprint do
  first_name
  last_name
  cv
end

Authorship.blueprint do
  author
  author_position {1}
end

Authorship.blueprint(:paper) do
  publication {Paper.make}
  publication_type {"Paper"}  
end

Authorship.blueprint(:book) do
  publication { Book.make }
  publication_type { "Book" }
end

Award.blueprint do
  name {Faker::Company.bs}
  description
  year
  cv
end

Book.blueprint do
  book_title {Sham.title}
  chapter_title{Sham.title}
  publisher
  isbn { Sham.issn }
  year 
  pages
  is_chapter true
end

Book.blueprint(:chapter) do 
  book_title {Sham.title}
  chapter_title nil
  is_chapter false
end

Certification.blueprint do
  name {Faker::Company.bs}
  cv
  date_received {Sham.date}
end

CmeCategory.blueprint do
  category {Faker::Lorem.words(1)}
end

Cme.blueprint do
  cme_category
  source {Faker::Company.name}
  user
  received_date {Sham.date}
  hours
end

Cv.blueprint do
  user
  public_address {Sham.last_name}
end

Education.blueprint do
  degree {"MD"}
  year
  description
  cv
end

Employment.blueprint do
  start_date {Sham.date}
  end_date {Sham.later_date}
  description
  cv
end

Faculty.blueprint do
  section
end

Institution.blueprint do
  name {Sham.publisher}
  location
  country "USA"
end

Institution.blueprint(:education) do
  experience_type {"Education"}
  experience {Education.make}
end

Institution.blueprint(:employment) do
  experience_type {"Employment"}
  experience {Employment.make}
end

Institution.blueprint(:training) do
  experience_type {"Training"}
  experience {Training.make}
end

Journal.blueprint do
  short_title {Sham.title}
  nlmuid
  long_title {Sham.title}
  issn
end

Membership.blueprint do
  organization {Sham.publisher}
  cv
  member_since {Sham.year}
end

Paper.blueprint do
  title
  pmid
  journal_year {Sham.year}
  journal_pages {Sham.pages}
  journal
end

Presentation.blueprint do
  title
  conference {Sham.publisher}
  location 
  given_at {Sham.date}
end

Rank.blueprint do
  name {Sham.publisher}
end

Section.blueprint do
  name {Sham.publisher}
end

Training.blueprint do
  level
  specialty
  year
  description
  cv
end

User.blueprint do
  last_name {Faker::Name.last_name}
  first_name {Faker::Name.first_name}
  username {Faker::Name.last_name}
  email {Faker::Internet.email}
  password {"testpassword"}
  password_confirmation {password}
  password_salt { Authlogic::Random.hex_token }
  crypted_password {Authlogic::CryptoProviders::Sha512.encrypt(password + password_salt)}
end
  
  


