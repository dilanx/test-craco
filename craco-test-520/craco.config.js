module.exports = {
  webpack: {
    configure: (webpackConfig) => {
      webpackConfig.optimization.splitChunks = {
        chunks: "all",
      };

      return webpackConfig;
    },
  },
};
