require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
    it {should validate_presence_of :email}
    it {should validate_uniqueness_of :email}
    it {should validate_presence_of :password_digest}

    it {should have_many :orders}
  end

  describe 'roles' do
    it "can be created as a default user" do
      user = User.create(name: "Pirate Jack",
                                    address: "123 Ocean Breeze",
                                    city: "Bootytown",
                                    state: "Turks & Caicos",
                                    zip: "13375",
                                    email: "pirate@thecarribean.com",
                                    password: "landlubberssuck",
                                    role: 0)

      expect(user.role).to eq("default")
      expect(user.default?).to be_truthy
    end
  end


  describe 'relationships' do
    it {should have_many :orders}
    it {should belong_to(:merchant).optional}
  end

  describe 'instance methods' do
    describe 'duplicate_email?' do
      it 'returns true if email already exists in system' do
        user_1 = User.create!(name: "Captain Daniel",
                              address: "7 Seas Drive",
                              city: "Port Saint Kitts",
                              state: "Arrrkansas",
                              zip: "13375",
                              email: "parrotcollector@avast.net",
                              password: "landlubberssuck",
                              password_confirmation: "landlubberssuck")
        user_2 = User.new(name: "Different Daniel",
                              address: "7 Seas Drive",
                              city: "Port Saint Kitts",
                              state: "Arrrkansas",
                              zip: "13375",
                              email: "parrotcollector@avast.net",
                              password: "landlubberssuck",
                              password_confirmation: "landlubberssuck")
        user_3 = User.new(name: "Yet Another Daniel",
                              address: "7 Seas Drive",
                              city: "Port Saint Kitts",
                              state: "Arrrkansas",
                              zip: "13375",
                              email: "nottheoriginaldaniel@avast.net",
                              password: "landlubberssuck",
                              password_confirmation: "landlubberssuck")

        expect(user_2.duplicate_email?).to eq(true)
        expect(user_3.duplicate_email?).to eq(false)
      end

      it 'created_date' do
        user_1 = User.create!(name: "Captain Daniel",
                              address: "7 Seas Drive",
                              city: "Port Saint Kitts",
                              state: "Arrrkansas",
                              zip: "13375",
                              email: "parrotcollector@avast.net",
                              password: "landlubberssuck",
                              password_confirmation: "landlubberssuck",
                              created_at: "2020-01-07 21:40:13 UTC")

        expect(user_1.created_date).to eq('January 07, 2020')
      end
    end
  end
end
