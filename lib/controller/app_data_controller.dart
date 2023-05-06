import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDataController extends ChangeNotifier {
  String? userId,accessToken,emailUser,displayName,photoURL;
  Map<String, String>? headersUser;
 String? syncDuration;
  bool? isAdmin=false;
  bool? multipleTask = true;
  bool? multipleReports = true;
  SharedPreferences? preferences;
  getDataForApp()async{
  preferences = await SharedPreferences.getInstance();
  photoURL=preferences!.getString("photoURL");
  displayName=preferences!.getString("displayName");
  syncDuration=preferences!.getString("syncDuration");
  emailUser=preferences!.getString("emailUser");
  accessToken=preferences!.getString("accessToken");
  userId=preferences!.getString("userId");
  isAdmin=preferences!.getBool("isAdmin");
  multipleReports=preferences!.getBool("multipleReports");
  multipleTask=preferences!.getBool("multipleTask");
  isAdmin??=false;
  multipleTask??=true;
  multipleReports??=true;
  photoURL??="";
  displayName??="";
  emailUser??="";
  accessToken??="";
  userId??="";
  print("$isAdmin isAdmin");
  notifyListeners();
}
  setMultipleStateTask()async{
    preferences = await SharedPreferences.getInstance();
    multipleTask=!multipleTask!;
    preferences!.setBool("multipleTask", multipleTask!);
    notifyListeners();
  }
  setMultipleStateReports()async{
    preferences = await SharedPreferences.getInstance();
    multipleReports=!multipleReports!;
    preferences!.setBool("multipleReports", multipleReports!);
    notifyListeners();
  }
  setSyncDuration(sync)async{
    preferences = await SharedPreferences.getInstance();
    syncDuration=sync;
    preferences!.setString("syncDuration", syncDuration!);
    notifyListeners();
  }

}