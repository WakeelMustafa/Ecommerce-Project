require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:line_items).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:images) }
  end


end
