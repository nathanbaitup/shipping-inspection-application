# Idwal Vessel Inspector

![https://codemagic.io/apps/6238b868854b7237ec0bc63f/6238b868854b7237ec0bc63e/latest_build](https://api.codemagic.io/apps/6238b868854b7237ec0bc63f/6238b868854b7237ec0bc63e/status_badge.svg)
***
This is the source code for the Idwal Vessel Inspection application, developed by Year 3 ASE students. This is a Flutter based application designed specifically for Android devices. This application allows a surveyor to conduct and complete a survey on a ship, with the option to communicate to a technical expert and share their viewfinder, to allow the expert to complete the survey remotely. This application makes use of ARCore, to help with remote inspections, ensuring the surveyor access to the section they are inspecting, the questions to look for and also what area they should be looking for relating to the questions to inspect. Agora is used for video calling to allow for two way A/V calling between a client and surveyor through a channel name.

## Technology Used:
***
Idwal Vessel Inspection is built using:
- [Dart][dart_tech] -  Used for application logic
- [Flutter][flutter_tech] - Used for application front-end development
- [Firebase][firebase] - Used for back-end data storage

- [Agora][agora_tech] - Used for video calling
- [ARCore][arcore_tech] - Used for AR modelling 
- [Microsoft Azure][azure] - Used to generate tokens for video calling
  
## Installation:
***

This setup will include installation for the application for installation onto an android device as well as work device for continued project development.

### Flutter installation:

As this is a flutter project, first you must ensure that Flutter is installed on your computer. This project has been built using Flutter version 2.10.0
To install Flutter on windows navigate to the flutter [website][flutter_install], where you will then be presented the option to select the device you want to install flutter on. Once selected a device you will then be given the latest stable release of flutter and installation documentation to ensure flutter is installed correctly.

### Setup :

1. Clone the repository into a folder of your choice using the following:
```
https://git.cardiff.ac.uk/c1927062/shipping-inspection-application.git
```
 _or_
2. Download and save the project in a folder of your choice using the provided .zip folder.
3. Once downloaded, open the project within your preferred IDE (Visual Studio, Android Studio). 
4. Run the command below to ensure that all dependencies are up to date before running the application.
```
flutter pub get
```

If you want to use an android emulator device, then please use Android Studio (See creating and initialising an emulator steps below). NOTE: video calling and AR do not work in an emulator and require an actual device. 


 
#### Running the project:
##### Android Device:
1. To run the project on an android device, first plug your android device into your computer.
2. Ensure that developer mode has been activated on your android device and that USB debugging has been enabled.
3. You should now see your device within the devices list on your IDE. Run the application in the IDE and this will build the application on your device.

##### Android Emulator:
1. To run the project on an emulator, follow the android emulator setup steps below, then open the emulator you just created. 
2. Once opened, you should see the emulator selected within the devices list on your IDE
3. Run the application in the IDE and this will build the application on the emulator.

##### Android Studio Emulator Setup:
 1. Open the project repository within android studio by navigating to where you downloaded the project and opening as a project within android studio.
 2. Once the project has opened, within the top right-hand corner of Android Studio, press on the image of a mobile device with an Android logo to open the AVD Manager.
 3. In the AVD manager, press create virtual device to open the virtual device configurator.
 ![AVD Manager](https://i.imgur.com/rGAcFHg.png)
 4. Select a Pixel 3A device from the settings and press next.
 5. If not already downloaded, download API levels 30 and 29 from the recommended system image for your device.
 6. Once downloaded, press next and finish.
 ![Settings List](https://i.imgur.com/zNF35Ra.png)
 7. Once the emulator has been created, close the AVD manager and navigate back to the top-right hand corner of Android Studio. Here, select the device that you just created.

## Documentation:
***

Below is a table of all the plugins that have been used within the development of this project. This table should be updated throughout the duration of development to ensure all team members know all packages that are used and their purpose.
Instructions on their use and documentation are provided below.

| Name | Version | UseCase |
| ------ | ------ | ------ |
| [flutter_image_slideshow][flutter_image_slideshow] | any | Used to create a image slideshow on the questionnaire_section page.  |
| [camera][camera] | 0.9.4 | Used to access the camera of a device to capture images on board a vessel and for video calling and AR use. |
| [path][path] | - | Used to get an image path to display the captured images on the application. |
| [flutter_test][flutter_test] | - | Used as the testing library for application testing.|
| [percent_indicator][percent_indicator] | - | Used to allow the inclusion of more aesthetically pleasing percentage indicators in the application.|
| [agora_rtc_engine][agora_rtc_engine] | 5.0.0 | Used to bring [Agora](https://www.agora.io/en/) Video calling functionality to the application.|
| [permission_handler][permission_handler] | 8.1.6 | Handles permissions on all platforms with one command (Android, iOS, Web).|
| [intl][intl] | 0.17.0 | Used to appropriately format date and time values.  |
| [settings_ui][settings_ui] | 2.0.2 | Used to display the settings menu found within the drawer menu.  |
| [ar_flutter_plugin][ar_flutter_plugin] | 0.6.2 | Used to implement Google ARCore within flutter to provide an AR experience when answering the survey. |
| [qr_code_scanner][qr_code_scanner]| 0.7.0 | Used to scan and interpret QR code data to open the AR scene in the application. |
| [permission_handler][permission_handler] | 8.0.0+1 | Used to request the permissions when initially launching the application. |
| [flutter_spinkit][flutter_spinkit] | 5.1.0 | Provides loading animations to the application |
| [internet_connection_checker][internet_connection_checker] | 0.0.1+3 | Provides the ability to check of the user is connected to the internet or not |
| [onboarding][onboarding] | 3.0.0 | Provides the ability to display a splash screen giving instructions on how to use a specific part of the application. |
| [screenshot][screenshot] | 1.2.3 | Used to capture and save the screenshot taking within the AR scene. |
| [splash_screen_view][splash_screen_view] | 3.0.0 | Creates a splash screen when the application is initially launched. |
|  [cloud_firestore][cloud_firestore] | 3.1.10 | Used to save data to Firebase Firestore. |
| [firebase_core][firebase_core] | 1.13.1 | Used to access Firebase. |
| [firebase_storage][firebase_storage] | 10.2.9 | Used to save data to Firebase Storage. |
| [shared_preferences][shared_preferences] | 2.0.13  | Used to access share_preferences.  |

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. Place all links to documentation used here to keep README clean. Ref: http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

[flutter_image_slideshow]: <https://github.com/edasandesu/flutter_image_slideshow>
[camera]: <https://github.com/flutter/plugins/tree/main/packages/camera/camera>
[path]: <https://github.com/dart-lang/path>
[percent_indicator]: <https://pub.dev/packages/percent_indicator>
[flutter_test]: <https://docs.flutter.dev/cookbook/testing>
[agora_rtc_engine]: <https://pub.dev/packages/agora_rtc_engine/versions/5.0.0>
[permission_handler]: <https://pub.dev/packages/permission_handler>
[intl]: <https://pub.dev/packages/intl>
[settings_ui]: <https://pub.dev/packages/settings_ui>
[ar_flutter_plugin]: <https://pub.dev/packages/ar_flutter_plugin>
[qr_code_scanner]: <https://pub.dev/packages/qr_code_scanner>
[permission_handler]: <https://pub.dev/packages/permission_handler>
[flutter_spinkit]: <https://pub.dev/packages/flutter_spinkit>
[dart_tech]: <https://dart.dev/>
[flutter_tech]: <https://flutter.dev/>
[agora_tech]: <https://www.agora.io/en/>
[arcore_tech]: <https://developers.google.com/ar>
[flutter_install]: <https://docs.flutter.dev/get-started/install>
[internet_connection_checker]: <https://pub.dev/packages/internet_connection_checker>
[onboarding]: <https://pub.dev/packages/onboarding>
[screenshot]: <https://pub.dev/packages/screenshot>
[splash_screen_view]: <https://pub.dev/packages/splash_screen_view>
[firebase]: <https://firebase.google.com/>
[firebase_storage]: <https://pub.dev/packages/firebase_storage>
[firebase_core]: <https://pub.dev/packages/firebase_core>
[cloud_firestore]: <https://pub.dev/packages/cloud_firestore>
[shared_preferences]: <https://pub.dev/packages/shared_preferences>
[azure]: <https://azure.microsoft.com/en-gb/>

