#!/bin/env node

var https = require('https');
var http = require('http');
var fs = require('fs');

var options = {
    hostname: 'api.ipsw.me',
    path: '/v2.1/firmwares.json/condensed',
    headers: {
        "User-Agent": "iFW/web-api"
    }
};

var sendUpdateNotification = function() {
    http.get('http://ifw-ninjaprawn.rhcloud.com/updateAPI', function(res) {
        console.log("Got response: " + res.statusCode);
        res.resume();
    }).on('error', function(e) {
        console.log("Got error:" + e.message);
    });
}

callback = function(response) {
    var json = '';

    response.on('data', function (chunk) {
        json += chunk;
    });

    response.on('end', function () {
        var jsonParsed = JSON.parse(json);
        fs.writeFile(process.env.OPENSHIFT_DATA_DIR+'/devices.json', JSON.stringify(jsonParsed["devices"]), function (err) {
            if (err) return console.log(err);
            console.log('Written!');
            sendUpdateNotification()
        });
    });
}

console.log("API update cron called!");
https.request(options, callback).end();
