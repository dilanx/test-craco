/* eslint-disable @typescript-eslint/no-var-requires */
const isAnalyze = process.env.ANALYZE;
const path = require("path");
const webpack = require("webpack");
const WebpackBundleAnalyzer =
  require("webpack-bundle-analyzer").BundleAnalyzerPlugin;
const StyleLintPlugin = require("stylelint-webpack-plugin");

const addPath = (dir) => path.resolve(__dirname, dir);

module.exports = () => {
  console.log(new Date().getTime());
  return {
    webpack: {
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      configure: (webpackConfig, { env, paths }) => {
        webpackConfig.plugins.push(
          new webpack.ContextReplacementPlugin(/moment[/\\]locale$/, /zh-cn/),
        );
        // analyze
        if (isAnalyze) webpackConfig.plugins.push(new WebpackBundleAnalyzer());

        webpackConfig.plugins.push(new StyleLintPlugin());

        return webpackConfig;
      },
      babel: {},
      style: {
        postcss: {
          mode: "file",
        },
      },
      eslint: {
        mode: "file",
      },
      externals: {},
      alias: {
        "@": addPath("./src"),
      },
    },
  };
};
