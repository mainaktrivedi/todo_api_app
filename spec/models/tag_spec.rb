require 'rails_helper'

RSpec.describe Tag, type: :model do
	describe "associations" do
    	it { should have_and_belong_to_many(:tasks) }
  	end
    describe "validations" do
	    it { is_expected.to validate_presence_of(:title) }
	    it { is_expected.to validate_uniqueness_of(:title) }
	end
end
