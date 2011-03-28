require 'ostruct'

module I18n
  def self.name_for_locale(locale)
    begin
      I18n.backend.translate(locale, :name, :scope => [:language])
    rescue I18n::MissingTranslationData
      locale.to_s
    end
  end
  
  def self.all_available_locales
    records = []
    
    available_locales.each do |locale|
      records << OpenStruct.new(:code => locale.to_s.downcase, :title => name_for_locale(locale))
    end
    
    records.sort_by(&:title)
  end
end
