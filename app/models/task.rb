class Task < ApplicationRecord
	include Suffixable

    #before_save :add_suffix

	validates :title, presence: true, uniqueness: true, length: { in: 1..50 }
	
	has_and_belongs_to_many :tags

	#belongs_to :category, optional: true
   
    def add_new_tag_if_not_present(title)
    	tg = Tag.where(title: title).first_or_create
    	self.tags << tg unless self.tags.contains?(tg)
    end
end
