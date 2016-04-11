#!/bin/env node

var https = require('https');

var options = {
    hostname: 'ipsw.me',
    path: '/updates.rss',
    headers: {
        "User-Agent": "iFW/web-api"
    }
};

callback = function(response) {
    var rss = '';

    response.on('data', function (chunk) {
        rss += chunk;
    });

    response.on('end', function () {
        console.log(str);
    });
}

https.request(options, callback).end();
