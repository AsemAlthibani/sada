import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sada/model/database_model/employees.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/database_helper.dart';
import '../../model/toast_model.dart';
import '../../screen/user/signup_screen.dart';


class UserController extends ChangeNotifier {
  final DatabaseHelper _databaseHelper=DatabaseHelper();
  TextEditingController username= TextEditingController();
  TextEditingController password= TextEditingController();
  TextEditingController email= TextEditingController();
  TextEditingController phone= TextEditingController();
  TextEditingController description= TextEditingController();
  int department_id=1;
  bool isAdmin=false;
  bool isNewUser=false;
  User? userAdd;
  String photoURL="";
  var idToken,accessToken,userId,headersUser;
  Future<User> signInWithGoogle(context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
    await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
    );
    accessToken= googleSignInAuthentication.accessToken;
    idToken= googleSignInAuthentication.idToken;
    headersUser=_googleSignIn.currentUser!.authHeaders;
    final UserCredential authResult =
    await _auth.signInWithCredential(credential);
    userAdd = (await _auth.signInWithCredential(credential)).user;
    final User? user = authResult.user;
    final AdditionalUserInfo? additionalUserInfo = authResult.additionalUserInfo;
    fetchData(context);
    if (additionalUserInfo!.isNewUser) {
      email.text=user!.email!;
      username.text=user.displayName!;
      email.text=user.email!;
      photoURL=user.photoURL!;
      isNewUser=true;
      notifyListeners();
      Navigator.of(context).pushNamedAndRemoveUntil('/SignUpScreen', (Route<dynamic> route) => false);
      print('New user logged in.');
    } else {
      await loginUser(false,context);
      print('Existing user logged in.');
    }
    return user!;
  }
  getData()async{

  }
  loginUser(isEmail,context)async{
    try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List dataList = [];
    if(isEmail){
    await FirebaseAuth.instance.
    signInWithEmailAndPassword(
      email: username.text,
      password: password.text,
    );
    }

    final User? users = FirebaseAuth.instance.currentUser;
    userId = users!.uid;
    print(photoURL.toString());
    notifyListeners();
    print("object");
    await FirebaseFirestore.instance.collection('Users').where('user_id', isEqualTo: userId).get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        dataList.add(doc.data());
      }),
    });
    print(dataList);
    if(dataList.isEmpty){
      print("isNotEmpty");
      email.text=users!.email!;
      username.text=users.displayName!;
      email.text=users.email!;
      photoURL=users.photoURL!;
      Navigator.of(context).pushNamedAndRemoveUntil('/SignUpScreen', (Route<dynamic> route) => false);
    }else{
    preferences.setString("displayName", dataList.last["user_name"].toString());
    preferences.setString("emailUser", dataList.last["user_email"].toString());
    preferences.setString("userId", dataList.last["user_id"].toString());
    preferences.setString("headersUser", headersUser.toString());
    preferences.setBool("isAdmin", dataList.last["isAdmin"]);
    if(!isEmail){
      await addDepartment();
      Navigator.of(context).pushNamedAndRemoveUntil('/MenuScreen', (Route<dynamic> route) => false);
      restData();
    }else{
      await addDepartment();
    }
    }} on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        print('The password provided is too weak.');
        Navigator.pop(context);
        ToastModel().getToastModel("كلمة المرور خاطئة");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Navigator.pop(context);
        ToastModel().getToastModel("البريد الاليكتروني قيد الاستخدام");
      } else if (e.code == 'invalid-email') {
        print('The account already exists for that email.');
        Navigator.pop(context);
        ToastModel().getToastModel("البريد الاليكتروني خاطئ ");
      }else{
        print(e.code);
      }
    } catch (e) {
      print(e.toString());
    }
    print("object");
  }
  userSetupData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("displayName", username.text.toString());
    preferences.setString("emailUser", email.text.toString());
    preferences.setString("userId", userId.toString());
    print("object");
  }
  Future<void> userSetup(context) async {
    try {
      UserCredential user =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      User? updateUser = FirebaseAuth.instance.currentUser;
      updateUser?.updateProfile(displayName: username.text);
      if (user.additionalUserInfo!.isNewUser) {
        isNewUser = true;
        FirebaseAuth auth = FirebaseAuth.instance;
        String uid = auth.currentUser!.uid.toString();
        await createUserData(uid);
        await userSetupData();
        print('New user logged in.');
      } else {
        isNewUser = false;
        print('Existing user logged in.');
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Navigator.pop(context);
        ToastModel().getToastModel("كلمة المرور المقدمة ضعيفة للغاية");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Navigator.pop(context);
        ToastModel().getToastModel("البريد الاليكتروني قيد الاستخدام");
      } else {
        print(e.code);
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
    return;
  }
  Future<void> createUserData(String uid) async{
    final CollectionReference profileList = FirebaseFirestore.instance.collection("Users");
    return await profileList.doc(uid).set({
      'user_name': username.text,
      'user_id': uid,
      "user_phone": phone.text,
      "user_email": email.text,
      "user_password": password.text,
      "isAdmin": true,
      "user_description": description.text,
      "department_id": department_id
    });}
  Future<void> addData(userId)async {

    return;
  }
  addDepartment()async{
    await _databaseHelper.deleteItemsDb("employees");
    await _databaseHelper.deleteSequenceItemsDb("employees");
    List jsonData=[];
    await FirebaseFirestore.instance.collection('Users').get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        jsonData.add(doc.data());
      }),
    });
    for(int i=0;i<jsonData.length;i++){
      print(jsonData[i]["isAdmin"]);
      Employees employees = Employees(isAdmin:jsonData[i]["isAdmin"]?1:0,
          user_id:jsonData[i]["user_id"], employees_name:jsonData[i]["user_name"],department_id:jsonData[i]["department_id"], );
      await _databaseHelper.insertToTableDB("employees",employees.toMap());
    }
  }
  restData(){
    description.text="";
    phone.text="";
    email.text="";
    password.text="";
    username.text="";
  }
}
/*
     preferences.setString("photoURL", photoURL.toString());
      preferences.setString("displayName", username.text.toString());
      preferences.setString("emailUser", email.text.toString());
      preferences.setString("accessToken", accessToken.toString());

 */

Future<void> userSetup(String user_name,user_password, user_phone, user_email, isAdmin,user_description,department_id) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid.toString();
  users.add({
    'user_name': user_name,
    'user_id': uid,
    "user_phone": user_phone,
    "user_email": user_email,
    "user_password": user_password,
    "isAdmin": true,
    "user_description": user_description,
    "department_id": department_id});
  return;
}
