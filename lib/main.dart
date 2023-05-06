import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sada/workmanager_callback.dart';
import 'package:sada/controller/task_report_controller.dart';
import 'package:sada/screen/screen_landing/landing_screen.dart';
import 'package:sada/screen/screen_landing/login_screen_landing.dart';
import 'package:sada/screen/small_screen/login/signup_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sada/workmanager_callback.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'controller/app_data_controller.dart';
import 'controller/firebase/drive_upload_controller.dart';
import 'controller/employees_controller.dart';
import 'controller/firebase/get_data_firestore_controller.dart';
import 'controller/firebase/login_and_register.dart';
import 'controller/firebase/post_data_firestore_controller.dart';
import 'controller/task_controller.dart';

import 'firebase_options.dart';
import 'language/codegen_loader.g.dart';
import 'model/database_helper.dart';
void main() async {
  DatabaseHelper _databaseHelper= DatabaseHelper();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  if ((defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux) && !kIsWeb) {
    // Initialize FFI to be able to use database with Windows/Linux
    // We use 'sqflite_ffi' if Linux or Windows, else we can use default sqlite (Android/IOS/Mac)
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    await _databaseHelper.initializeRestaurantDb();
    // Change the default factory

  }else{
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
    await Workmanager().cancelAll();
    await _databaseHelper.initializeRestaurantDb();
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString("userId");
  bool? isAdmin = prefs.getBool("isAdmin");
  isAdmin??=false;
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
  runApp(
    EasyLocalization(
      path: 'assets/translations/',
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      fallbackLocale:  const Locale('ar'),
      assetLoader:  const CodegenLoader(),
      startLocale:const Locale('ar'),
      child: MyApp(userId:userId,isAdmin:isAdmin),
    ),
  );  });
}


class MyApp extends StatelessWidget {
  String? userId;
  bool? isAdmin;

  MyApp({this.userId, this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskController>(
        create: (_) => TaskController(),
        child: ChangeNotifierProvider<UserController>(
            create: (_) => UserController(),
            child: ChangeNotifierProvider<AppDataController>(
                create: (_) => AppDataController(),
                child: ChangeNotifierProvider<EmployeesController>(
                    create: (_) => EmployeesController(),
                    child: ChangeNotifierProvider<GetDataFirestoreController>(
                        create: (_) => GetDataFirestoreController(),
                        child: ChangeNotifierProvider<
                            PostDataFirestoreController>(
                            create: (_) => PostDataFirestoreController(),
                            child: ChangeNotifierProvider<
                                DriveUploadController>(
                                create: (_) => DriveUploadController(),
                                child: ChangeNotifierProvider<
                                    TaskReportController>(
                                    create: (_) => TaskReportController(),
                                    child:
                                    MaterialApp(
                                      supportedLocales: context
                                          .supportedLocales,
                                      localizationsDelegates: context
                                          .localizationDelegates,
                                      locale: context
                                          .locale,
                                      routes: <String,
                                          WidgetBuilder>{
                                        '/MenuScreen': (BuildContext context) =>
                                        const MenuScreenLanding(),
                                        '/LoginScreen': (
                                            BuildContext context) =>
                                        const LoginScreenLanding(),
                                        '/SignUpScreen': (
                                            BuildContext context) =>
                                            SignUpScreen(),
                                        '/AdminMenuScreen': (
                                            BuildContext context) =>
                                        const AdminMenuScreenLanding(),
                                      },
                                      debugShowCheckedModeBanner: false,
                                      title: 'Sada',
                                      theme: ThemeData(
                                        primarySwatch: Colors
                                            .teal,
                                        fontFamily: "TS-Safaa",),
                                      home: userId ==
                                          null ?
                                      const LoginScreenLanding()
                                          : isAdmin!
                                          ? const AdminMenuScreenLanding()
                                          : const MenuScreenLanding(),
                                    )
                                )
                            )
                        )
                    )
                ))));
  }
}