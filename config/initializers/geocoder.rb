Geocoder.configure(
  lookup: :google,

  api_key: Rails.application.credentials[:map_api_key],

  language: :ja,

  timeout: 5,

  units: :km
)
