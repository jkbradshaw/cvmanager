class Authorship < ActiveRecord::Base
  belongs_to :author
  belongs_to :publication, :polymorphic => true
  delegate :last_name, :first_name, :to => :author
  after_destroy :remove_orphaned_author
  
  private
    def remove_orphaned_author
      author.destroy if author.publications.count == 0
    end
  
end
