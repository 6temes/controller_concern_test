# spec/models/current_spec.rb

require 'rails_helper'

RSpec.describe Current do
  describe '.country' do
    it 'defaults to nil' do
      expect(Current.country).to be_nil
    end

    it 'can be set' do
      Current.country = 'AU'
      expect(Current.country).to eq('AU')
    end
  end

  describe '.locale' do
    it 'defaults to nil' do
      expect(Current.locale).to be_nil
    end

    it 'can be set' do
      Current.locale = 'en'
      expect(Current.locale).to eq('en')
    end
  end
end
