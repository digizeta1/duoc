/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        duoc: {
          primary: '#003057',
          secondary: '#002240',
          gold: '#E9B949',
        },
      },
    },
  },
  plugins: [],
};