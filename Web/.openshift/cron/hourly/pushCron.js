#!/bin/env node

var https = require('https');
var http = require('http');
var fastFeed = require('fast-feed');
var fs = require('fs');

var options = {
    hostname: 'ipsw.me',
    path: '/updates.rss',
    headers: {
        "User-Agent": "iFW/web-api"
    }
};

var sendNotification = function(content) {
    http.get('http://ifw-ninjaprawn.rhcloud.com/pushNotification?content='+encodeURIComponent(content), function(res) {
        console.log("Got response: " + res.statusCode);
        res.resume();
    }).on('error', function(e) {
        console.log("Got error:" + e.message);
    });
}

callback = function(response) {
    var rss = '';

    response.on('data', function (chunk) {
        rss += chunk;
    });

    response.on('end', function () {
        rss = rss.replace(/bst/gi, "GMT+0100")
        fastFeed.parse(rss, function(err, feed) {
            if (err) throw err;
            fs.readFile(process.env.OPENSHIFT_DATA_DIR+'/recent.json', 'utf-8', function(err, content) {
                if (err) throw err;
                var cachedRecent = content;
                var titles = [];
                for (var i = 0; i < feed["items"].count; i++) {
                    if (JSON.stringify(feed["items"][i]) == cachedRecent) {
                        break;
                    }
                    titles.append(feed["items"][i]["title"]);
                }
                if (titles.length > 0) {
                    fs.writeFile(process.env.OPENSHIFT_DATA_DIR+'/recent.json', JSON.stringify(feed["items"][0]), function (err) {
                        if (err) return console.log(err);
                        console.log('Written!');
                    });
                    titles.forEach(function(element, index, array) {
                        sendNotification(element);
                    });
                }
            });
        });
    });
}

https.request(options, callback).end();
