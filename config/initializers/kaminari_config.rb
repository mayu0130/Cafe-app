# frozen_string_literal: true

Kaminari.configure do |config|
  config.default_per_page = 8
+ config.window = 1
end
