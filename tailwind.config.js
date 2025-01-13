module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/views/devise/**/*.html.erb',
  ],
  theme: {
    extend: {
      colors: {
        teal: '#7CD1D0',
        brown: '#7B5544',
        cream: '#FAF0E6',
        darkGray: '#444B4D',
        lightPink: '#FDF7F3',
      },
      animation: {
        fade: 'fadeOut 3s forwards',
      },
    },
  },
  plugins: [
    require('daisyui'),
  ],
  daisyui: {
    darkTheme: false,
    themes: [
      {
        mytheme: {
          primary: "#7CD1D0",
          secondary: "#7B5544",
          accent: "#FAF0E6",
          neutral: "#444B4D",
          "base-100": "#FDF7F3",
        },
      },
    ],
  },
};
