# iFW

App for <a href="https://ipsw.me/">ipsw.me</a>

State of Project
----------
Project is currently 65% on the way. Currently on Push Notifications handling.
Need to add Push Notifications handling, better API. Then bug fixes/enhancements.
ETA: 15/04/16

Turns out PN was pretty easy, it's just how to send the notifications based on new content from the updates feed that will be a challenge. 

NOTE: I will probably **not** open source the handling and the custom api until I clean it up and make it look good.

Building
----------
First, either download the repo or clone it:
```bash
git clone https://github.com/ninjaprawn/iFW.git
```

Then install with CocoaPods:
```bash
pod install
```

Libraries/Frameworks
----------

iFW uses the following libraries/frameworks:
- Alamofire
- SwiftyJSON
- SwiftRSS
- Realm

License
----------
MIT license. So just don't recompile and ship it under your own name. If you do use components from this project, just credit me :)
