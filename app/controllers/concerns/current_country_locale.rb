module CurrentCountryLocale
  extend ActiveSupport::Concern

  included do
    before_action :set_country_and_locale
  end

  private

  def set_country_and_locale
    set_country
    set_locale
  end

  def set_country
    Current.country ||= (params[:country] || AUSTRALIA_COUNTRY_CODE.downcase)
  end

  def set_locale
    Current.locale ||= params[:locale] || I18n.default_locale
  end
end
