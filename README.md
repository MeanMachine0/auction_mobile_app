# auction_mobile_app
A Flutter app that fetches JSON data from a REST API built in a Django web app via token authentication.
![App Icon]https://firebasestorage.googleapis.com/v0/b/auction-mobile-app.appspot.com/o/readMeImages%2Flogo.png?alt=media&token=096751d4-5e89-4264-a0b3-3ac014669698

## Functions
### When not logged in
- View recently sold items and their corresponding details and images.
- View active items and their corresponding details and images.
- View users' profiles (includes their listings).

### When logged in (in addition to when not logged in)
- Bid on active items.
- List an item with an image.
- View your own profile (includes your own listings and items you have previously bidded on).

## Firebase Integration
- Stores a significantly downscaled image (browsing view) and a moderately downscaled image (listing view) of items.
- App distribution - testing on both android and ios.
- Crashlytics - logs crash reports.
- Monitor performance stats.

## Aims
- To broaden my knowledge of mobile software development.
- To develop proficiency in Flutter.
- To improve my API development skills.
- To learn how to integrate firebase into a mobile app.
