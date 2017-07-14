var webpack = require( 'webpack' );
var merge = require( 'webpack-merge' );
var ExtractTextPlugin = require( 'extract-text-webpack-plugin' );
var HtmlWebpackPlugin = require( 'html-webpack-plugin' );
var CopyWebpackPlugin = require( 'copy-webpack-plugin' );
var Dotenv = require( 'dotenv-webpack' );
var AssetsPlugin = require('assets-webpack-plugin');

var config = {
  context: __dirname + '/src',
  entry: {
    app: './index.js',
  },

  output: {
    //    path: __dirname + '/dist',
    //    filename: 'elm.js',
    path: __dirname + '/../',
    filename: 'js/[hash]-elm.js',
  },

  resolve: {
    extensions: ['.js', '.elm']
  },

  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [{
          loader: 'elm-webpack-loader',
        }]
      },
      {
        test: /\.(css|scss)$/,
        use: ExtractTextPlugin.extract(
          {
            fallback: "style-loader",
            use: [
              'css-loader',
              'postcss-loader',
              'sass-loader'
            ]
          }
        )
      }
    ]
  },

  plugins: [
    new ExtractTextPlugin('css/[hash]-styles.css'),
    new Dotenv({
      path: './env',
      safe: true
    }),
  ],

};

if (process.env.NODE_ENV === "production") {
  module.exports = merge( config, {
    devtool: "",

    plugins: [
      new AssetsPlugin({
        path: '../includes',
      }),
    ],

  });
} else { // development environment
  module.exports = merge( config, {
    devServer: {
      contentBase: __dirname + 'src',
      host: 'http://elixir.officeiko.co.jp',
      port: 8000,
    },
    
    devtool: "eval-srouce-map",

    plugins: [
      new HtmlWebpackPlugin({
        template: 'index.html',
        filename: 'index.html',
        inject: 'body'
      })
    ]
  });
}
