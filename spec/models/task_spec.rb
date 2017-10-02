require 'rails_helper'

RSpec.describe Task, type: :model do
	describe "associations" do
    	it { should have_and_belong_to_many(:tags) }
  	end
    describe "validations" do
	    it { is_expected.to validate_presence_of(:title) }
	    it { is_expected.to validate_uniqueness_of(:title) }
	end
	describe "task can not have duplicate tags" do

		let :new_task do
			tsk = Task.create({title: "test task"})
		end
		let :new_tag do
			tg = Tag.create({title: "test tag"})
		end
		before do
			new_task.tags << new_tag
			#new_task.save
			#new_task.tags << tg
			#new_task.save
		end
		it "task does not have duplicate tags" do
			expect(new_task.tags.count).to eq(1)
		end
		it "raises error for duplicate tag" do
			expect {new_task.tags << new_tag}.to raise_error(ActiveRecord::RecordNotUnique)
	    end

	end
end
