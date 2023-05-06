import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'controller/firebase/get_data_firestore_controller.dart';
import 'controller/firebase/post_data_firestore_controller.dart';


FlutterLocalNotificationsPlugin   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const rescheduledTaskKey = "be.tramckrijte.workmanagerExample.rescheduledTask";
const failedTaskKey = "be.tramckrijte.workmanagerExample.failedTask";
@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher(context) async {
  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/sada2');

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  WidgetsFlutterBinding.ensureInitialized();

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().executeTask((task, inputData) async {

    final prefs = await SharedPreferences.getInstance();

    String? displayName = prefs.getString('displayName');
      switch (task) {
        case rescheduledTaskKey:
          final bool? value = prefs.getBool('Sync');
          bool? PosNotification = prefs.getBool('PosNotification');
          var userId=prefs.getString("userId");
          bool? isAdmin=prefs.getBool("isAdmin");
          isAdmin??=false;
          if(value!) {
            PosNotification??=true;
            await Provider.of<PostDataFirestoreController>(context, listen: false).postDataToFirebase(userId,isAdmin);
            await Provider.of<GetDataFirestoreController>(context, listen: false).postDataToFirebase(userId,isAdmin);
            if(!PosNotification) {
              await showNotification('تمت مزامنة بيانتك',"مرحبا $displayName",);
            }
          }
          break;

      }
    return true;
  });

}

 showNotification(fs,first_name) async {
print("hhhhhhhhhhhhhhhhhhhhhhhhhh");
  AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    '0',
    'Sada',
    channelDescription:"Sada Notification",
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    largeIcon: DrawableResourceAndroidBitmap('@mipmap/sada2'),
  );
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    first_name,
    fs,
    platformChannelSpecifics,
  );
print("nnnnnnnnnnnnnnnnnnnnnnnnnnnn");
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
