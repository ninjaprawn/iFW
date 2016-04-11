# iFW for the web

This part of the project consists of two parts: Push Notification handler and the API

NOTE: Both components are made with Node.js, using the REST api from OneSignal to push notifications and X for rss parsing.

The cron jobs are located in <code>.openshift/cron/hourly/</code>

Push Notification Handler
----------
This is pretty much a cron job that runs hourly. It caches the most recent post. If the post isn't the recent one on refresh, the app gets the data, processes it and sends the notifications out. The latest post is cached. 

API
----------
2 parts. First is with the hourly cron thing. This pretty much gets any new data and saves it with only the needed keys. Second part is the web fetch thing. Client (iOS app) send a request with the following things:
- Device count (for new devices check)
- Device code : Firmware count

If the above are the same, the API just returns a firmware signing status (don't think its fast though).

Maybe while I'm working on the API, I'll think of a more efficient way (date related?).
