import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/database_helper.dart';

class AppDataController extends ChangeNotifier {
  String? userId,accessToken,emailUser,displayName,photoURL;
  Map<String, String>? headersUser;
  bool? isAdmin=false;
getDataForApp()async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  photoURL=preferences.getString("photoURL");
  displayName=preferences.getString("displayName");
  emailUser=preferences.getString("emailUser");
  accessToken=preferences.getString("accessToken");
  userId=preferences.getString("userId");
  isAdmin=preferences.getBool("isAdmin");
  isAdmin??=false;
  photoURL??="";
  displayName??="";
  emailUser??="";
  accessToken??="";
  userId??="";
  print("$isAdmin isAdmin");
  notifyListeners();
}
  Future<Map<String, String>> get authHeaders async {
    return <String, String>{
      'Authorization': 'Bearer $accessToken',
      // TODO(kevmoo): Use the correct value once it's available from authentication
      // See https://github.com/flutter/flutter/issues/80905
      'X-Goog-AuthUser': '0',
    };
  }
}