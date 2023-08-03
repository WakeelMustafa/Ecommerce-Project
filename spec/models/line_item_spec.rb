require 'rails_helper'

RSpec.describe LineItem, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:product) }
  end

  describe "validations" do
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end

end
