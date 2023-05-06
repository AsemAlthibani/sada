import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sada/model/database_model/note.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' as io;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis/drive/v3.dart';
import 'package:path/path.dart' as path;
import 'package:sada/controller/google_auth_client.dart';
import '../../model/database_helper.dart';
import '../../model/database_model/reports_uploaded.dart';
import '../../model/toast_model.dart';
import '../../screen/small_screen/widget/custom_progress_dialog.dart';
import '../../screen/small_screen/widget/update_task_widget.dart';


class DriveUploadController extends ChangeNotifier {
  int type = 1;
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
  TextEditingController adminNot = TextEditingController();
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
       type: FileType.custom,
       allowedExtensions: ['pdf'],
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
  Future<void> uploadFileToGoogleDrive(context,userId,displayName,isAdmin)async{
    try {
    await Future.delayed(Duration(seconds: 1));
    var client = GoogleHttpClient(await account!.authHeaders);
    var drive = ga.DriveApi(client);
    PlatformFile file = result!.files.first;
    final filePath = result!.files.single.path!;
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
    await addFileUploaded(userId,fileUrl,filePath,displayName,isAdmin);
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
  getFileUploaded(userId)async{
    if(type==1){
    listReportsUploaded=await _databaseHelper.retrieveReportsUploadedFromDb('SELECT * FROM reports_uploaded where create_by="$userId"');
    }else if(type==2){
      listReportsUploaded=await _databaseHelper.retrieveReportsUploadedFromDb('SELECT * FROM reports_uploaded where create_by!="$userId"');
    }
    notifyListeners();
  }
  addFileUploaded(userId,file_url,file_path,displayName,isAdmin) async {
    var date=DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", "en").format(DateTime.now());
    ReportsUploaded reportsUploaded=ReportsUploaded(
        create_by_name:displayName,
        create_by:userId,
        file_url:file_url,
        file_name:fileName.text,
        file_path:file_path,
        isAdmin:isAdmin?1:0,
        downloaded: 0,
        date:date,
        not:not.text,
        api:1);
    int id=await _databaseHelper.insertToTableDB("reports_uploaded", reportsUploaded.toMap());
    await postFileUploadedToFirebase(file_url,file_path, fileName.text, displayName, userId,not.text,date,id,isAdmin);
  }
  Future<void> postFileUploadedToFirebase(file_url,file_path, file_name, create_by_name, create_by,not,date,id,isAdmin)async{
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
    "downloaded": 0,
    "isAdmin":isAdmin,
    "api": 1,
    "admin_add": false});
    await docRef.update({'id': docRef.id});
  }
  OpenResult? _openResult;
  Future<void> openFile(String filePath) async {
    print(filePath);
    final result = await OpenAppFile.open(filePath);
      _openResult = result;
    print(_openResult == null
        ? 'Result: none'
        : 'Result: ${_openResult?.type}\nMessage: ${_openResult?.message}');
    if(_openResult?.type.toString() == "ResultType.fileNotFound" || _openResult == null){
      ToastModel().getToastModel("الملف غير موجود في المسار");
    }
      notifyListeners();
  }
  Future<String> downloadFile(String url, String filename,context) async {
    if (kIsWeb) {
      return url;
    }
    showUpdateProgress(context);
    String dir = (await getTemporaryDirectory()).path;
    io.File targetFile = io.File('$dir/$filename');
    final httpClient = Client();
    var request = await httpClient.get(Uri.parse(url));
    var response = request.bodyBytes;
    await targetFile.writeAsBytes(response);
    Navigator.pop(context);
    print(targetFile.path);
    return targetFile.path;
  }
  Future<void> openFileUrl(String fileUrl) async {
    try {
      await canLaunch(fileUrl)
          ? await launch(fileUrl)
          : throw 'Could not launch $fileUrl';
    } catch (e) {
      print(e);
    }
  }
  setType(value) {
    type = value;
    notifyListeners();
  }
  addNoteFileUploaded(ReportsUploaded reports,userId,displayName,isAdmin,note_type) async {
    var date=DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", "en").format(DateTime.now());
    AdminNote adminNote=AdminNote(
      note_description: adminNot.text,
      emp_id: reports.create_by,
      updated:1,
      reports_id:reports.online_id ,
      isAdmin: isAdmin?1:0,
      api: 0,
      create_by: userId,
      create_by_name: displayName,
      emp_name: reports.create_by_name,
      date: date,
      note_type: note_type,
      new_add: 0);
    int id=await _databaseHelper.insertToTableDB("admin_note", adminNote.toMap());
    print("$id id");
  }

}