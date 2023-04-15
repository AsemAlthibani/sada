import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis/drive/v3.dart';
import 'package:path/path.dart' as path;
import 'package:sada/screen/user/signup_screen.dart';

import '../../../../controller/google_auth_client.dart';
import '../../controller/firebase/login_and_register.dart';
import '../../model/color_model.dart';

//Get Google Account
GoogleSignInAccount? account;
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/drive.file',
  ],
);

class DriveScreen extends StatefulWidget {
  @override
  DriveScreenState createState() {
    return new DriveScreenState();
  }
}

class DriveScreenState extends State<DriveScreen> {
  @override
  void initState() {
    // TODO: implement initState
    login();
    super.initState();
  }
  //Drive Api
  DriveApi? api;
  //FilesList
  ga.FileList? list;
  //Progress Dialog
  //Scaffold Key
  GlobalKey<ScaffoldState> _scaffold = GlobalKey();

  //Main UI Widget
  @override
  Widget build(BuildContext context) {
    bool isorientation= MediaQuery.of(context).orientation == Orientation.landscape;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter, colors: [
                ColorsModel.ColorsMineLite,  ColorsModel.ColorsMineLite],
              ),

            ),
          ),
          backgroundColor: ColorsModel.ColorsMineLite,
          title: Text(
            "رفع التقاير",
            style: TextStyle(
                fontFamily: "TS-Safaa",
                color: Colors.white,
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.w500
            ),
          ),

          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white
            ),),
          actions: [


          ]

      ),
      floatingActionButton:FloatingActionButton(
        onPressed: _uploadFileToGoogleDrive,
        backgroundColor: ColorsModel.ColorsMineLite,
        child: Icon(Icons.add),
        tooltip: 'Upload File',
      ),
      body: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: FutureBuilder(
                    initialData: null,
                    future: api?.files.list(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState !=
                          ConnectionState.done) {
                        return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Loading Files',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      fontSize: 18),
                                ),
                              ],
                            ));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Something went wrong'),
                        );
                      } else {
                        return ListView(
                          physics: BouncingScrollPhysics(),
                          children: (snapshot.data as FileList)
                              .files!
                              .map((f) => ListTile(
                            dense: true,
                            onTap:(){
                              print(f.toJson());
                            },
                            title: Text(
                              f.name!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                            leading: Icon(
                              Icons.insert_drive_file,
                              color: Colors.black,
                            ),
                          ))
                              .toList(),
                        );
                      }
                    }),
              ),
            ],
          )
      ),
    );

  }

  //Login Method
  Future<void> login() async {
    try {

      account = await _googleSignIn.signIn();
      final client = GoogleHttpClient(await _googleSignIn.currentUser!.authHeaders);
      api = ga.DriveApi(client);
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
    setState(() {});
  }

  //Upload Method
  _uploadFileToGoogleDrive() async {
    var client = GoogleHttpClient(await account!.authHeaders);
    var drive = ga.DriveApi(client);
    ga.File fileToUpload = ga.File();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    PlatformFile file = result!.files.first;
    String? fa=file.path;
    fileToUpload.name = path.basename(fa!);
    if (result != null) {

      fetchData(context);

      var response = await drive.files.create(fileToUpload);
      final permission = ga.Permission()
        ..type = 'anyone'
        ..role = 'reader';

      await api?.permissions.create(
        permission,
        response.id.toString(),
        sendNotificationEmail: false,
      );
      Map<String, dynamic>? fileLink =(await api?.files.get(response.id.toString(),)) as Map<String, dynamic>?;
      final webViewLink = fileLink?['webViewLink'];
      print(webViewLink);
      fileLink!.forEach((key, value) {print(value);});
      
      print("${fileLink} fileLink");
      print(response.webContentLink);
      print(response.writersCanShare);
      Navigator.pop(context);
      setState(() {
        _listGoogleDriveFiles();
      });
    }}

  //Listing Files Method
  Future<void> _listGoogleDriveFiles() async {
    var client = GoogleHttpClient(await account!.authHeaders);
    var drive = ga.DriveApi(client);
    drive.files.list().then((value) {
      setState(() {
        list = value;
        for (var i = 0; i < list!.files!.length; i++) {
          print("Id: ${list!.files![i].id} File Name:${list!.files![i].name}");
        }
      });
    });
  }

  //Logout Method
  void logout() {
    _googleSignIn.signOut();
    setState(() {
      account = null;
    });
  }


  Widget loginScreen(){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Google Drive Access'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CupertinoButton(
              color: Colors.blue,
              child: Text('Sign in with Google'),
              onPressed: (){
                logout();
              }),
        ),
      ),
    );
  }
}
