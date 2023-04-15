import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sada/screen/admin/admin_menu_screen.dart';
import 'package:sada/screen/user/login_screen.dart';
import 'package:sada/screen/user/menu_screen.dart';
import 'package:sada/screen/user/signup_screen.dart';
import 'package:sada/workmanager_callback.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'controller/app_data_controller.dart';
import 'controller/employees_controller.dart';
import 'controller/firebase/login_and_register.dart';
import 'controller/task_controller.dart';
import 'language/codegen_loader.g.dart';
import 'model/database_helper.dart';
void main() async {
  DatabaseHelper _databaseHelper= DatabaseHelper();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  await Workmanager().cancelAll();
  await SystemChrome.setPreferredOrientations([
  ]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString("userId");
  bool? isAdmin = prefs.getBool("isAdmin");
  isAdmin??=false;
  await _databaseHelper.initializeRestaurantDb();
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
  );
}


class MyApp extends StatelessWidget {
  String? userId;
  bool? isAdmin;
  MyApp({this.userId,this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskController>(
        create: (_) => TaskController(),
        child:ChangeNotifierProvider<UserController>(
        create: (_) => UserController(),
    child:ChangeNotifierProvider<AppDataController>(
    create: (_) => AppDataController(),
    child:ChangeNotifierProvider<EmployeesController>(
    create: (_) => EmployeesController(),
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
                MenuScreen(),
            '/LoginScreen': (BuildContext context) =>
             LoginScreen(),
            '/SignUpScreen': (BuildContext context) =>
             SignUpScreen(),
            '/AdminMenuScreen': (BuildContext context) =>
                AdminMenuScreen(),
          },
          debugShowCheckedModeBanner: false,
          title: 'Sada',
          theme: ThemeData(
            primarySwatch: Colors
                .teal,
            fontFamily: "TS-Safaa",),
          home: userId ==
              null ?
          LoginScreen()
              : isAdmin!?AdminMenuScreen():MenuScreen(),
        )
    ))));
  }
}
