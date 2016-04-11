#!/bin/env node

var express = require('express');
var fs = require('fs');

var app = express();

// Push Notification function
var sendNotification = function(data, callback) {
    var headers = {
        "Content-Type": "application/json",
        "Authorization": "Basic 'yours'"
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
            callback(data);
        });
    });

    req.on('error', function(e) {
        callback(e);
    });

    req.write(JSON.stringify(data));
    req.end();
};

// Server Setup for express app
var ipaddress = process.env.OPENSHIFT_NODEJS_IP;
var port = process.env.OPENSHIFT_NODEJS_PORT || 8080;

if (typeof ipaddress === "undefined") {
    console.warn('No OPENSHIFT_NODEJS_IP var, using 127.0.0.1');
    ipaddress = "127.0.0.1";
};

// Logging why node was killed
var terminated = function(sig) {
    if (typeof sig === "string") {
       console.log('%s: Received %s - terminating iFW-web ...', Date(Date.now()), sig);
       process.exit(1);
    }
    console.log('%s: Node server stopped.', Date(Date.now()));
};

process.on('exit', function() {
    terminated();
});

var signals = ['SIGHUP', 'SIGINT', 'SIGQUIT', 'SIGILL', 'SIGTRAP', 'SIGABRT', 'SIGBUS', 'SIGFPE', 'SIGUSR1', 'SIGSEGV', 'SIGUSR2', 'SIGTERM'];
signals.forEach(function(element, index, array) {
    process.on(element, function() {
        terminated(element);
    });
});

// File cache so its faster to load the files and to request them from urls
var fileCache = {};
fileCache['index.html'] = fs.readFileSync('./index.html');

app.get("/", function(req, res) {
    res.setHeader('Content-Type', 'text/html');
    res.send(fileCache['index.html']);
});

app.get("/pushNotification", function(req, res) {
    var content = req.query.content;
    var message = {
      app_id: "'yours'",
      contents: {"en": content},
      included_segments: ["All"]
    };

    sendNotification(message, function(response) {
        res.json(JSON.parse(response));
    });
});

// Listen for start of server
app.listen(port, ipaddress, function() {
    console.log('%s: Node server started on %s:%d ...', Date(Date.now() ), ipaddress, port);
});
