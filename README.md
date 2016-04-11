# iFW

App for <a href="https://ipsw.me/">ipsw.me</a>

Thanks to <a href="https://twitter.com/pxtvr">peter</a> for the help and motivation (not directly, but still, ty)

State of Project
----------
Project is currently 85% on the way. Currently working on bug fixes/enhancements.

ETA: 15/04/16

Building
----------
<h4>iOS</h4>
First, either download the repo or clone it:
```bash
git clone https://github.com/ninjaprawn/iFW.git
```

Then install with CocoaPods (you need to have <a href="https://cocoapods.org/">cocoapods</a> and <a href="https://github.com/orta/cocoapods-keys">cocoapods-keys</a> installed):
```bash
pod install
```

<h4>Web</h4>
Most of the details are discussed in that folder. Pretty much you have to change a lot of things when uploading the folder to OpenShift. I've only added the source so you can see what's going on.

Libraries/Frameworks
----------

iFW uses the following libraries/frameworks:
- Alamofire
- SwiftyJSON
- SwiftRSS
- Realm
- OneSignal

License
----------
MIT license. So just don't recompile and ship it under your own name. If you do use components from this project, just credit me :)
