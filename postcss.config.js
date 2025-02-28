module.exports = {
  plugins: {
    "@tailwindcss/postcss": {},
    autoprefixer: {},
    "postcss-url": {
      url: "inline",
      basePath: "/app/assets",
      assetsPath: "public/assets",
      useHash: true,
    },
  },
};
