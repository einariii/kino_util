/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./lib/assets/*.js"],
  theme: {
    extend: {
      colors: {
        'utilblue': '#61AFEF',
        'utilyellow': '#C6D200',  
        'utilgreen': '#98C379',
        'utilpink': '#DA70D6',
        'utilred': '#E06C75'
      }
    },
  },
  plugins: [],
};
