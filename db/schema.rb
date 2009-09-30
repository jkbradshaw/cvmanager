This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090927175257) do

  create_table "addresses", :force => true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cv_id"
  end

  create_table "authors", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "cv_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "trainee",    :default => false
  end

  create_table "authorships", :force => true do |t|
    t.integer  "publication_id"
    t.string   "publication_type"
    t.integer  "author_id"
    t.integer  "author_position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "awards", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cv_id"
  end

  create_table "books", :force => true do |t|
    t.string   "book_title"
    t.string   "chapter_title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "publisher"
    t.string   "isbn"
    t.integer  "year",          :limit => 255
    t.string   "pages"
    t.boolean  "is_chapter"
  end

  create_table "certifications", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cv_id"
    t.date     "date_received"
  end

  create_table "cme_categories", :force => true do |t|
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cmes", :force => true do |t|
    t.string   "source"
    t.integer  "user_id"
    t.date     "received_date"
    t.integer  "hours"
    t.integer  "cme_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cv", :force => true do |t|
    t.integer  "user_id"
    t.string   "public_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "education", :force => true do |t|
    t.integer  "year"
    t.string   "degree"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cv_id"
  end

  create_table "employment", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cv_id"
  end

  create_table "faculty", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "section_id"
    t.date     "start_date"
    t.integer  "user_id"
    t.integer  "leadership"
    t.integer  "clinical_rvu"
    t.integer  "medstudent_teaching"
    t.integer  "resident_teaching"
  end

  create_table "ignored_authors", :force => true do |t|
    t.integer  "author_id"
    t.integer  "cv_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "institutions", :force => true do |t|
    t.string   "name"
    t.string   "location"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "experience_id"
    t.string   "experience_type"
  end

  create_table "journals", :force => true do |t|
    t.string   "issn"
    t.float    "impact",      :default => 1.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "long_title"
    t.string   "short_title"
    t.string   "nlmuid"
  end

  create_table "memberships", :force => true do |t|
    t.string   "organization"
    t.integer  "member_since"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cv_id"
  end

  create_table "papers", :force => true do |t|
    t.string   "title"
    t.string   "pmid"
    t.string   "journal_volume"
    t.string   "journal_issue"
    t.integer  "journal_year"
    t.string   "journal_pages"
    t.text     "abstract"
    t.string   "paper_type"
    t.date     "pmed_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pub_model"
    t.integer  "journal_id"
  end

  create_table "presentations", :force => true do |t|
    t.string   "title"
    t.string   "conference"
    t.string   "location"
    t.date     "given_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ranks", :force => true do |t|
    t.string   "name"
    t.boolean  "trainee"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "authorizable_type"
    t.string   "authorizable_id"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "training", :force => true do |t|
    t.string   "level"
    t.string   "specialty"
    t.integer  "year"
    t.text     "description"
    t.integer  "cv_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persistence_token"
    t.string   "last_name"
    t.string   "first_name"
  end

end
