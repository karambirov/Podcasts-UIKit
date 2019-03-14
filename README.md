# Podcasts
This is a clone of Apple's Podcasts. Final version will be built with RxSwift using MVVM and Coordinator.

## Screenshots

<p align="center">
  <img src = "https://user-images.githubusercontent.com/6949755/54340090-a5375500-4647-11e9-8124-87794e1c2c05.png" width="220"/>
  <img src = "https://user-images.githubusercontent.com/6949755/54340091-a5375500-4647-11e9-844d-e6a5cd78fd44.png" width="220"/>
  <img src = "https://user-images.githubusercontent.com/6949755/54340092-a5cfeb80-4647-11e9-8cf7-3b9b4892b20c.png" width="220"/>
  <img src = "https://user-images.githubusercontent.com/6949755/54340093-a5cfeb80-4647-11e9-84a1-2de51cdc0ccc.png" width="220"/>
  <img src = "https://user-images.githubusercontent.com/6949755/54340095-a5cfeb80-4647-11e9-8ae5-f758aaa3014e.png" width="220"/>
  <img src = "https://user-images.githubusercontent.com/6949755/54340096-a5cfeb80-4647-11e9-853c-fa0aa9128d34.png" width="220"/>
</p>


## Screen recording
<p align="center">
  <img src = "https://user-images.githubusercontent.com/6949755/54339127-f42fbb00-4644-11e9-96e3-18ff515e5323.gif" width="200"/>
</p>

## App Features
- [x] Searching for podcasts using iTunes API.
- [x] Saving info about favorite podcasts on disk, so a user can see them offline.
- [x] Downloading episodes for listening to without an Internet connection.

## Technologies
- [x] Networking REST API v3 ([Moya](https://github.com/Moya/Moya)).
- [x] JSON parsing using `Codable`.
- [x] XML parsing podcasts' meta information ([FeedKit](https://github.com/nmdias/FeedKit)).
- [x] Programmatically UI ([SnapKit](https://github.com/SnapKit/SnapKit)).
- [x] [SwiftLint](https://github.com/realm/SwiftLint) - A tool to enforce Swift style and conventions.
- [x] [R.swift](https://github.com/mac-cain13/R.swift) - Get strong typed, autocompleted resources like images, fonts and segues in Swift projects.

## Building and Running
Make sure you have Xcode installed from the App Store. Then run the following commands in Terminal:

```sh
clone https://github.com/Karambirov/Podcasts.git
cd Podcasts
pod install
open Podcasts.xcworkspace
```

## License
MIT License. See [LICENSE](https://github.com/Karambirov/Podcasts/blob/develop/LICENSE).
