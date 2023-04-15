import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis/drive/v3.dart';
import 'package:path/path.dart' as path;
import 'package:sada/controller/google_auth_client.dart';
import '../model/database_helper.dart';
import '../model/database_model/reports_uploaded.dart';
import '../model/toast_model.dart';
import '../screen/small_screen/widget/update_task_widget.dart';


class DriveUploadController extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  DriveApi? api;
  FilePickerResult? result;
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  List<ReportsUploaded> listReportsUploaded=[];
  GoogleSignInAccount? account;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/drive.file',
    ],
  );
  TextEditingController not = TextEditingController();
  TextEditingController fileName = TextEditingController();

  Future<void> login() async {
    try {
      bool result = await InternetConnectionChecker().hasConnection;
      if(result){
        account = await _googleSignIn.signIn();
      final client = GoogleHttpClient(await _googleSignIn.currentUser!.authHeaders);
      api = ga.DriveApi(client);
      }else{
        ToastModel().getToastModel("الرجاء الارتباط بالانترنيت");
      }
    } catch (error) {
      print('DriveScreen.login.ERROR... $error');
      SnackBar(
        backgroundColor: Colors.red.shade700,
        content: Text(
          'Error : $error',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  //Logout Method
  void logout() {
    _googleSignIn.signOut();
      account = null;
      notifyListeners();
  }

  getFileFromDevice(context,userId,size) async {
    result=null;
     result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null) {
      PlatformFile file = result!.files.first;
      String? path=file.name.split('.').last;
      String? allName=file.name;
      String? name=allName.substring(0,allName.length-(path.length+1));
      fileName.text=name;
      not.text="";
      showReportsUploaded(context,size);
    }
    notifyListeners();
  }
  Future<void> uploadFileToGoogleDrive(context,userId,displayName)async{
    try {
    await Future.delayed(Duration(seconds: 1));
    var client = GoogleHttpClient(await account!.authHeaders);
    var drive = ga.DriveApi(client);
    PlatformFile file = result!.files.first;
    String? fa=file.path;
    ga.File fileToUpload = ga.File();
    fileToUpload.name = path.basename(fa!);
    var response = await drive.files.create(fileToUpload,supportsAllDrives: true);
    final permission = ga.Permission()
      ..type = 'anyone'
      ..role = 'reader';
    await api?.permissions.create(
    permission,
    response.id.toString(),
    sendNotificationEmail: false,
    );
    var fileId = response.id.toString();
    var fileUrl = 'https://drive.google.com/file/d/' + fileId + '/view';
    print("$fileUrl fileUrl");
    print(response.webContentLink);
    print(response.writersCanShare);
    await addFileUploaded(userId,fileUrl,fa,displayName);
    } catch (error) {
      print('DriveScreen.login.ERROR... $error');
      SnackBar(
        backgroundColor: Colors.red.shade700,
        content: Text(
          'Error : $error',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }
  getFileUploaded()async{
    listReportsUploaded=await _databaseHelper.retrieveReportsUploadedFromDb();
    notifyListeners();
  }
  addFileUploaded(userId,file_url,file_path,displayName) async {
    var date=DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", "en").format(DateTime.now());
    ReportsUploaded reportsUploaded=ReportsUploaded(
        create_by_name:displayName,
        create_by:userId,
        file_url:file_url,
        file_name:fileName.text,
        file_path:file_path,
        date:date,
        not:not.text,
        api:1);
    int id=await _databaseHelper.insertToTableDB("reports_uploaded", reportsUploaded.toMap());
    await postFileUploadedToFirebase(file_url,file_path, fileName.text, displayName, userId,not.text,date,id);
  }
  Future<void> postFileUploadedToFirebase(file_url,file_path, file_name, create_by_name, create_by,not,date,id)async{
    await Firebase.initializeApp();
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('ReportsUploaded');
    DocumentReference docRef = await collectionRef.add({
    'offline_id': id,
    'date': date,
    "not": not,
    'create_by': create_by,
    'create_by_name': create_by_name,
    'file_name': file_name,
    'file_path': file_path,
    "file_url": file_url,
    "api": 1,
    "admin_add": false});
    await docRef.update({'id': docRef.id});
  }
}