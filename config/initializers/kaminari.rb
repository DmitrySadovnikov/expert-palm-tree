Kaminari.configure do |config|
  config.default_per_page = Rails.configuration.application[:pagination][:default_per_page]
  config.max_per_page = Rails.configuration.application[:pagination][:default_max_per_page]
end
