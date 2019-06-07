#!/bin/bash

PROJECT_NAME=$1

echo "Creating AWS Amplify Project - $PROJECT_NAME"

mkdir -p $PROJECT_NAME/src && cd $PROJECT_NAME
touch package.json index.html webpack.config.js src/app.js

PACKAGE_JSON=$(cat <<EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "Amplify app",
  "dependencies": {},
  "devDependencies": {
    "webpack": "^4.17.1",
    "webpack-cli": "^3.1.0",
    "copy-webpack-plugin": "^4.5.2",
    "webpack-dev-server": "^3.1.5"
  },
  "scripts": {
    "start": "webpack && webpack-dev-server --mode development",
    "build": "webpack"
  }
}
EOF
)

echo "${PACKAGE_JSON}" > package.json
npm install

BOILER_HTML=$(cat <<EOF
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>$PROJECT_NAME</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
            html, body { font-family: "Amazon Ember", "Helvetica", "sans-serif"; margin: 0; }
            a { color: #FF9900; }
            h1 { font-weight: 300; }
            .app { width: 100%; }
            .app-header { color: white; text-align: center; background: linear-gradient(30deg, #f90 55%, #FFC300); width: 100%; margin: 0 0 1em 0; padding: 3em 0 3em 0; box-shadow: 1px 2px 4px rgba(0, 0, 0, .3); }
            .app-logo { width: 126px; margin: 0 auto; }
            .app-body { width: 400px; margin: 0 auto; text-align: center; }
            .app-body button { background-color: #FF9900; font-size: 14px; color: white; text-transform: uppercase; padding: 1em; border: none; }
            .app-body button:hover { opacity: 0.8; }
        </style>
    </head>
    <body>
        <div class="app">
            <div class="app-header">
                <div class="app-logo">
                    <img src="https://aws-amplify.github.io/images/Logos/Amplify-Logo-White.svg" alt="AWS Amplify" />
                </div>
                <h1>Welcome to the Amplify Framework - $PROJECT_NAME</h1>
            </div>
            <div class="app-body">
                <button id="AnalyticsEventButton">Generate Analytics Event</button>
                <div id="AnalyticsResult"></div>
            </div>
        </div>
        <script src="main.bundle.js"></script>
    </body>
</html>
EOF
)

echo "${BOILER_HTML}" > index.html


WEBPACK_CONFIG=$(cat <<EOF
const CopyWebpackPlugin = require('copy-webpack-plugin');
const webpack = require('webpack');
const path = require('path');

module.exports = {
    mode: 'development',
    entry: './src/app.js',
    output: {
        filename: '[name].bundle.js',
        path: path.resolve(__dirname, 'dist')
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /node_modules/
            }
        ]
    },
    devServer: {
        contentBase: './dist',
        overlay: true,
        hot: true
    },
    plugins: [
        new CopyWebpackPlugin(['index.html']),
        new webpack.HotModuleReplacementPlugin()
    ]
};
EOF
)

echo "${WEBPACK_CONFIG}" > webpack.config.js

echo "Adding amplify to project, initializing and adding analytics service..."

npm install --save aws-amplify
amplify init
amplify add analytics
amplify push

echo BOILER_ANALYTICS_JS=$(cat <<EOF
import Auth from '@aws-amplify/auth';
import Analytics from '@aws-amplify/analytics';

import awsconfig from './aws-exports';

// retrieve temporary AWS credentials and sign requests
Auth.configure(awsconfig);
// send analytics events to Amazon Pinpoint
Analytics.configure(awsconfig);

const AnalyticsResult = document.getElementById('AnalyticsResult');
const AnalyticsEventButton = document.getElementById('AnalyticsEventButton');
let EventsSent = 0;

AnaltyicsEventButton.addEventListener('click', (event) => {
  const { aws_mobile_analytics_app_region, aws_mobile_analytics_app_id } = awsconfig;

  Analytics.record('Amplify Tutorial Event')
    .then((event) => {
      const url = `https://${aws_mobile_analytics_app_region}.console.aws.amazon.com/pinpoint/home/?region=${aws_mobile_analytics_app_region}#/apps/${aws_mobile_analytics_app_id}/analytics/events`;
      AnalyticsResult.innerHTML = '<p>Event Submitted. </p>';
      AnalyticsResult.innerHTML += '<p>Events sent: '+(++EventsSent)+'</p>';
      AnalyticsResult.innerHTML += '<a href="'+url+'" target="_blank">View Events on the Amazon Pinpoint Console</a>';
    });
EOF
)

echo "${BOILER_ANALYTICS_JS}" > src/app.js

echo "Project now has analytics service set-up!"

npm start
echo "Project created! - http://localhost:8080"

