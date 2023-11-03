require 'rails_helper'

RSpec.describe RoomRate, type: :model do
  describe 'validations' do
    it 'daily_rate must be present' do
      room_rate = RoomRate.new

      expect(room_rate.valid?).to eq false
    end

    it 'daily_rate must be greater than 0' do
      room_rate = RoomRate.new(daily_rate: 0)

      expect(room_rate.valid?).to eq false
    end

    it 'start_date must be present' do
      room_rate = RoomRate.new

      expect(room_rate.valid?).to eq false
    end

    it 'end_date must be present' do
      room_rate = RoomRate.new

      expect(room_rate.valid?).to eq false
    end
  end
end
