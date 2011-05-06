# encoding: utf-8
module Sunrise
  module Utils
  
    # "Продвинутый" бекэнд для I18n.
    # 
    # Наследует Simple бекэнд и полностью с ним совместим. Добаляет поддержку 
    # для отдельностоящих/контекстных названий дней недели и месяцев.
    # Также позволяет каждому языку использовать собственные правила плюрализации,
    # объявленные как Proc (<tt>lambda</tt>).
    # 
    #
    # Advanced I18n backend.
    #
    # Extends Simple backend. Allows usage of "standalone" keys
    # for DateTime localization and usage of user-defined Proc (lambda) pluralization
    # methods in translation tables.
    class I18nBackend < ::I18n::Backend::Simple
      include ::I18n::Backend::Pluralization
      
      LOCALIZE_ABBR_MONTH_NAMES_MATCH = /(%d|%e)(.*)(%b)/
      LOCALIZE_MONTH_NAMES_MATCH = /(%d|%e)(.*)(%B)/
      LOCALIZE_STANDALONE_ABBR_DAY_NAMES_MATCH = /^%a/
      LOCALIZE_STANDALONE_DAY_NAMES_MATCH = /^%A/
      
      # Acts the same as +strftime+, but returns a localized version of the 
      # formatted date string. Takes a key from the date/time formats 
      # translations as a format argument (<em>e.g.</em>, <tt>:short</tt> in <tt>:'date.formats'</tt>).
      #
      #
      # Метод отличается от <tt>localize</tt> в Simple бекэнде поддержкой 
      # отдельностоящих/контекстных названий дней недели и месяцев.
      #
      #
      # Note that it differs from <tt>localize</tt> in Simple< backend by checking for 
      # "standalone" month name/day name keys in translation and using them if available.
      #
      # <tt>options</tt> parameter added for i18n-0.3 compliance.
      def localize(locale, object, format = :default, options = nil)
        raise ArgumentError, "Object must be a Date, DateTime or Time object. #{object.inspect} given." unless object.respond_to?(:strftime)
        
        type = object.respond_to?(:sec) ? 'time' : 'date'
        # TODO only translate these if format is a String?
        formats = translate(locale, :"#{type}.formats")
        format = formats[format.to_sym] if formats && formats[format.to_sym]
        # TODO raise exception unless format found?
        format = format.to_s.dup

        # TODO only translate these if the format string is actually present
        # TODO check which format strings are present, then bulk translate then, then replace them

        if lookup(locale, :"date.standalone_abbr_day_names")
          format.gsub!(LOCALIZE_STANDALONE_ABBR_DAY_NAMES_MATCH, 
            translate(locale, :"date.standalone_abbr_day_names")[object.wday])
        end
        format.gsub!(/%a/, translate(locale, :"date.abbr_day_names")[object.wday])
        
        if lookup(locale, :"date.standalone_day_names")
          format.gsub!(LOCALIZE_STANDALONE_DAY_NAMES_MATCH, 
            translate(locale, :"date.standalone_day_names")[object.wday])
        end
        format.gsub!(/%A/, translate(locale, :"date.day_names")[object.wday])

        if lookup(locale, :"date.standalone_abbr_month_names")
          format.gsub!(LOCALIZE_ABBR_MONTH_NAMES_MATCH) do
            $1 + $2 + translate(locale, :"date.abbr_month_names")[object.mon]
          end
          format.gsub!(/%b/, translate(locale, :"date.standalone_abbr_month_names")[object.mon])
        else
          format.gsub!(/%b/, translate(locale, :"date.abbr_month_names")[object.mon])
        end

        if lookup(locale, :"date.standalone_month_names")
          format.gsub!(LOCALIZE_MONTH_NAMES_MATCH) do
            $1 + $2 + translate(locale, :"date.month_names")[object.mon]
          end
          format.gsub!(/%B/, translate(locale, :"date.standalone_month_names")[object.mon])
        else
          format.gsub!(/%B/, translate(locale, :"date.month_names")[object.mon])
        end

        format.gsub!(/%p/, translate(locale, :"time.#{object.hour < 12 ? :am : :pm}")) if object.respond_to? :hour
        object.strftime(format)
      end
    end
  end
end
