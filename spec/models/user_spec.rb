require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:products) }
    it { should have_many(:comments) }
    it { should have_many(:line_items) }
  end

  describe "validations" do
    it { should validate_presence_of(:firstname) }
    it { should validate_presence_of(:lastname) }
  end

  describe "before_create callback" do
    it "concatenates firstname and lastname into fullname" do
      user = FactoryBot.create(:user, firstname: "John", lastname: "Doe")
      expect(user.fullname).to eq("John Doe")
    end
  end

  describe "Devise modules" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
  end
end
