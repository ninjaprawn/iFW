#!/bin/env node

var sendNotification = function(data) {
var headers = {
"Content-Type": "application/json",
"Authorization": "Basic 'Get your own'"
};

var options = {
host: "onesignal.com",
port: 443,
path: "/api/v1/notifications",
method: "POST",
headers: headers
};

var https = require('https');
var req = https.request(options, function(res) {
res.on('data', function(data) {
  console.log("Response:");
  console.log(JSON.parse(data));
});
});

req.on('error', function(e) {
console.log("ERROR:");
console.log(e);
});

req.write(JSON.stringify(data));
req.end();
};

var message = {
app_id: "'Get yours!'",
contents: {"en": "Hourly cron!"},
included_segments: ["All"]
};

sendNotification(message);
