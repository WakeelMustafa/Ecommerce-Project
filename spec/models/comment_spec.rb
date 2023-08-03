require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "associations" do
    it { should belong_to(:product) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:text) }
    it { should validate_length_of(:text).is_at_most(25) }
  end
end
