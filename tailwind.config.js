module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/views/devise/**/*.html.erb'
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
      fontSize: {
        12: '0.75rem',      // 12px
        14: '0.875rem',     // 14px
        16: '1rem',         // 16px
        18: '1.125rem',     // 18px
        20: '1.25rem',      // 20px
        22: '1.375rem',     // 22px
        24: '1.5rem',       // 24px
        26: '1.625rem',     // 26px
        28: '1.75rem',      // 28px
        30: '1.875rem',     // 30px
        32: '2rem',         // 32px
        34: '2.125rem',     // 34px
        36: '2.25rem',      // 36px
      },
      animation: {
        fade: 'fadeOut 3s forwards', // フェードアウトのアニメーションを3秒で実行
      },
      keyframes: {
        fadeOut: {
          '0%': { opacity: '1' },
          '80%': { opacity: '1' },
          '100%': { opacity: '0' },
        },
      }, // ここを追加
    },
  },
  plugins: [],
};
