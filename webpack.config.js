var path = require('path');
var webpack = require('webpack');

var babelOpts = {presets: ['latest']};
var devDir = path.join(__dirname, 'dev');

module.exports = {
  devtool: 'source-map',
  entry: {
    app: path.join(devDir, 'sidebar.js')
  },
  output: {
    path: path.join(__dirname, 'pub/System/SidebarPlugin'),
    filename: 'sidebar.js'
  },
  resolve: {
    extensions: ['.vue', '.js']
  },
  watchOptions: {
    aggregateTimeout: 250,
    ignored: '/node_modules/',
    poll: 1000
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        loader: 'vue-loader',
        include: [devDir],
         options: {
           loaders: {
            js:'babel-loader?' + JSON.stringify(babelOpts)
          },
       }
      },
      {
        test: /\.js$/,
        loader: 'babel-loader',
        include: [devDir],
        options: babelOpts
      },
      {
        test: /\.s(a|c)ss$/,
        include: [devDir],
        use: ['style-loader','css-loader', 'sass-loader']
      }
    ]
  }
}
