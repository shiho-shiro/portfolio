CountrySelect::FORMATS[:with_alpha2] = lambda do |country|
  "#{country.translations[I18n.locale.to_s]} (#{country.alpha2})"
end
