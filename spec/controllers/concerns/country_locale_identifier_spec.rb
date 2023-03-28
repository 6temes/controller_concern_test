require 'rails_helper'

RSpec.describe CountryLocaleIdentifier, type: :controller do
  controller(ApplicationController) do
    include CountryLocaleIdentifier

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

  describe 'before_action :set_country_and_locale' do
    context 'when the user does not have an active session' do
      it 'sets country in session' do
        get :index, params: { country: 'ad' }
        expect(session[:country]).to eq('ad')
      end

      it 'sets default country if country is not provided' do
        get :index
        expect(session[:country]).to eq(australia_country_code)
      end

      it 'sets locale in session' do
        get :index, params: { locale: 'ca_AD' }
        expect(session[:locale]).to eq('ca_AD')
      end

      it 'sets default locale if locale is not provided' do
        get :index
        expect(session[:locale]).to eq(default_locale)
      end
    end

    context 'when the user already has an active session' do
      before do
        session[:country] = 'ch'
        session[:locale] = 'fr_CH'
      end

      it 'does not overwrite existing country value in session' do
        get :index, params: { country: 'ad' }
        expect(session[:country]).to eq('ch')
      end

      it 'does not overwrite existing locale value in session' do
        get :index, params: { locale: 'ca_AD' }
        expect(session[:locale]).to eq('fr_CH')
      end
    end
  end
end
