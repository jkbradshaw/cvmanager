

require 'rubygems'
require 'faster_csv'


FCSV.foreach('journal impact.csv') do |row|
  next if row[0]=='short_title'
  short_title = row[0].titlecase
  issn = row[1]
  impact = row[2]
  long_title = row[3]
  nlmuid = row[4]
  j = Journal.find_or_create_by_nlmuid(nlmuid)
  j.issn = issn
  j.impact = impact
  j.long_title = long_title
  j.short_title = short_title
  j.save
end

