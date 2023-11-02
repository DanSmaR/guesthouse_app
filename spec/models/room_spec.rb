require 'rails_helper'

RSpec.describe Room, type: :model do
  describe 'validations' do
    it 'name must be present' do
      room = Room.new(name: '', description: 'Quarto com vista para a serra', size: 30,
                      max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                      air_conditioning: true, tv: true, wardrobe: true, safe: true,
                      accessible: true, available: true)

      room.valid?

      expect(room.errors[:name]).to include('não pode ficar em branco')
    end

    it 'size must be present' do
      room = Room.new(name: 'Quarto 1', description: 'Quarto com vista para a serra', size: '',
                      max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                      air_conditioning: true, tv: true, wardrobe: true, safe: true,
                      accessible: true, available: true)

      room.valid?

      expect(room.errors[:size]).to include('não pode ficar em branco')
    end

    it 'max_people must be present' do
      room = Room.new(name: 'Quarto 1', description: 'Quarto com vista para a serra', size: 30,
                      max_people: '', daily_rate: 100, bathroom: true, balcony: true,
                      air_conditioning: true, tv: true, wardrobe: true, safe: true,
                      accessible: true, available: true)

      room.valid?

      expect(room.errors[:max_people]).to include('não pode ficar em branco')
    end

    it 'daily_rate must be present' do
      room = Room.new(name: 'Quarto 1', description: 'Quarto com vista para a serra', size: 30,
                      max_people: 2, daily_rate: '', bathroom: true, balcony: true,
                      air_conditioning: true, tv: true, wardrobe: true, safe: true,
                      accessible: true, available: true)

      room.valid?

      expect(room.errors[:daily_rate]).to include('não pode ficar em branco')
    end

    it 'bathroom must be present' do
      room = Room.new(name: 'Quarto 1', description: 'Quarto com vista para a serra', size: 30,
                      max_people: 2, daily_rate: 100, bathroom: '', balcony: true,
                      air_conditioning: true, tv: true, wardrobe: true, safe: true,
                      accessible: true, available: true)

      room.valid?

      expect(room.errors[:bathroom]).to include('não pode ficar em branco')
    end

    it 'balcony must be present' do
      room = Room.new(name: 'Quarto 1', description: 'Quarto com vista para a serra', size: 30,
                      max_people: 2, daily_rate: 100, bathroom: true, balcony: '',
                      air_conditioning: true, tv: true, wardrobe: true, safe: true,
                      accessible: true, available: true)

      room.valid?

      expect(room.errors[:balcony]).to include('não pode ficar em branco')
    end

    it 'air_conditioning must be present' do
      room = Room.new(name: 'Quarto 1', description: 'Quarto com vista para a serra', size: 30,
                      max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                      air_conditioning: '', tv: true, wardrobe: true, safe: true,
                      accessible: true, available: true)

      room.valid?

      expect(room.errors[:air_conditioning]).to include('não pode ficar em branco')
    end

    it 'tv must be present' do
      room = Room.new(name: 'Quarto 1', description: 'Quarto com vista para a serra', size: 30,
                      max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                      air_conditioning: true, tv: '', wardrobe: true, safe: true,
                      accessible: true, available: true)

      room.valid?

      expect(room.errors[:tv]).to include('não pode ficar em branco')
    end

    it 'wardrobe must be present' do
      room = Room.new(name: 'Quarto 1', description: 'Quarto com vista para a serra', size: 30,
                      max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                      air_conditioning: true, tv: true, wardrobe: '', safe: true,
                      accessible: true, available: true)

      room.valid?

      expect(room.errors[:wardrobe]).to include('não pode ficar em branco')
    end

    it 'safe must be present' do
      room = Room.new(name: 'Quarto 1', description: 'Quarto com vista para a serra', size: 30,
                      max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                      air_conditioning: true, tv: true, wardrobe: true, safe: '',
                      accessible: true, available: true)

      room.valid?

      expect(room.errors[:safe]).to include('não pode ficar em branco')
    end

    it 'accessible must be present' do
      room = Room.new(name: 'Quarto 1', description: 'Quarto com vista para a serra',
                      size: 30, max_people: 2, daily_rate: 100, bathroom: true,
                      balcony: true, air_conditioning: true, tv: true, wardrobe: true,
                      safe: true, accessible: '', available: true)

      room.valid?

      expect(room.errors[:accessible]).to include('não pode ficar em branco')
    end

    it 'available must be present' do
      room = Room.new(name: 'Quarto 1', description: 'Quarto com vista para a serra',
                      size: 30, max_people: 2, daily_rate: 100, bathroom: true,
                      balcony: true, air_conditioning: true, tv: true, wardrobe: true,
                      safe: true, accessible: true, available: '')

      room.valid?

      expect(room.errors[:available]).to include('não pode ficar em branco')
    end
  end
end
