# Pin npm packages by running ./bin/importmap

pin 'turbo-rails', to: 'turbo.min.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'
