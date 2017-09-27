class Task < ApplicationRecord
	validates :title, presence: true, uniqueness: true, length: { in: 1..50 }
	has_and_belongs_to_many :tags
end
