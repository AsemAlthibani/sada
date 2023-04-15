import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'model/toast_model.dart'; //For Android devices
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

    String? first_name = prefs.getString('first_name');
      switch (task) {
        case rescheduledTaskKey:
          final bool? value = prefs.getBool('Sync');
          bool? PosNotification = prefs.getBool('PosNotification');
          if(value!) {
            String? state = prefs.getString('biller_id');
            String? user_id = prefs.getString('id');
            String? warehouse_id = prefs.getString('warehouse_id');
            PosNotification??=false;
          //  await updateDatabaseSyncViewModelDio.UpdateSynchronizationDatabase(user_id,warehouse_id);
            if(!PosNotification) {
              await showNotification('لقد تمت مزامنة مبيعاتك الى النظام وتحديث بيانات التطبيق',"مرحبا $first_name",);
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
    'Arkan Pos',
    channelDescription:"Arkan Pos Notification",
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    largeIcon: DrawableResourceAndroidBitmap('@mipmap/home'),
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

