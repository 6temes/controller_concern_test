# spec/controllers/concerns/current_country_locale_spec.rb

require 'rails_helper'

RSpec.describe CurrentCountryLocale do
  controller(ApplicationController) do
    include CurrentCountryLocale

    def index
      render plain: 'Success'
    end
  end

  let(:australia_country_code) { 'au' }
  let(:default_locale) { 'en_AU' }

  before do
    stub_const('AUSTRALIA_COUNTRY_CODE', australia_country_code)
    allow(I18n).to receive(:default_locale).and_return(default_locale)
  end

  CurrentMock = Struct.new(:country, :locale)
  let(:current_mock) { CurrentMock.new }

  before do
    allow(Current).to receive(:instance).and_return(current_mock)
  end

  around do |example|
    current_mock.country = nil
    current_mock.locale = nil
    example.run
  end

  describe 'before_action :set_country_and_locale' do
    context 'when Current attributes are not set' do
      it 'sets country in Current' do
        get :index, params: { country: 'ad' }
        expect(Current.country).to eq('ad')
      end

      it 'sets default country if country is not provided' do
        get :index
        expect(Current.country).to eq(australia_country_code)
      end

      it 'sets locale in Current' do
        get :index, params: { locale: 'ca_AD' }
        expect(Current.locale).to eq('ca_AD')
      end

      it 'sets default locale if locale is not provided' do
        get :index
        expect(Current.locale).to eq(default_locale)
      end
    end

    context 'when Current attributes are already set' do
      before do
        Current.country = 'ch'
        Current.locale = 'fr_CH'
      end

      it 'does not overwrite existing country value in Current' do
        get :index, params: { country: 'ad' }
        expect(Current.country).to eq('ch')
      end

      it 'does not overwrite existing locale value in Current' do
        get :index, params: { locale: 'ca_AD' }
        expect(Current.locale).to eq('fr_CH')
      end
    end
  end
end
