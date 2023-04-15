import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../controller/app_data_controller.dart';
import '../../model/color_model.dart';
import '../../workmanager_callback.dart';



class SettingsScreen extends StatefulWidget {
  _SettingsScreen createState() => _SettingsScreen();

}

class _SettingsScreen extends State<SettingsScreen> {
  bool? isSwitched10 = false;
  bool? isSwitched11 = false;
  bool? isSwitched9 = false;
  var TimerSyncDuration;
  SharedPreferences? prefs;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    final AppDataController appData = Provider.of<AppDataController>(context, listen: true);
    bool isorientation = MediaQuery.of(context).orientation == Orientation.landscape;

    return
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter, colors: [
                  ColorsModel.ColorsMineLite, ColorsModel.ColorTherdLite],
                ),

              ),
            ),
            backgroundColor: ColorsModel.ColorsMineLite,
            title: Text(
             "الاعدادات",
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height:  size.height * 0.22,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50)
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter, colors: [
                    ColorsModel.ColorsMineLite, ColorsModel.ColorTherdLite],
                  ),

                ),
                child:Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        width: size.height * 0.11,
                        height: isorientation
                            ? size.height * 0.19
                            : size.height * 0.11,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child:

                            appData.photoURL==""
                                ||appData.photoURL==null
                                ||appData.photoURL=="null"?
                            Icon(
                              Icons.person,
                              color: Colors.white,
                              size: size.width * 0.1,
                            ):CachedNetworkImage(
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              imageUrl: appData.photoURL!,
                              fit: BoxFit.cover,
                            ))

                    ),
                    Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child:
                      Text(appData.displayName!,
                        style: TextStyle(
                          fontFamily: "Almarai",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isorientation?size.width * 0.04:size.width * 0.05,
                        ),
                      ),
                    ),

                  ],),
              ),
              customTitle(size, isorientation, "المزامنة"),
              customBody(size, isorientation, isorientation?size.height * 0.73:size.height * 0.32, Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customCupertinoSwitch(size, isorientation, "المزامنة التلقائية", Icons.sync, isSwitched10!,  (value)async {
                      setState(() {
                        isSwitched10 = value;
                        prefs?.setBool(
                            "Sync",
                            isSwitched10!);
                      });
                      if(value){
                        await Workmanager().registerPeriodicTask(
                          rescheduledTaskKey,
                          rescheduledTaskKey,
                          frequency: const Duration(hours: 1),
                          initialDelay: const Duration(minutes: 1),
                          constraints: Constraints(networkType: NetworkType.connected),
                        );}else{
                        await Workmanager().cancelByUniqueName(rescheduledTaskKey);
                      }
                    }),
                    customCupertinoSwitch(size, isorientation, "الغاء اشعارات المزامنة", Icons.close, isSwitched11!,  (value)async {
                      setState(() {
                        isSwitched11 = value;
                        prefs?.setBool(
                            "PosNotification",
                            isSwitched11!);
                      });
                    }),

                    customInsideBodyV2(size, isorientation, "مدة المزامنة",  "1 ساعة",
                        Icons.cloud_sync_sharp, Icons.arrow_back_ios_new_sharp, (){
                          //SyncDurations(context,size);
                        }),
                    customInsideBodyV2(size, isorientation,"تمت المزامنة في ", TimerSyncDuration == null
                        ? "1 "
                        :TimerSyncDuration.toString(),
                        Icons.duo_rounded, Icons.arrow_back_ios_new_sharp, (){
                        }),
                  ])),
            ],
          ),
        ), floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            child: InkWell(
                onTap: () {
                  showDialogs(context);
                },
                child: Container(
                  width: double.infinity,
                  height: size.height * 0.1,
                  alignment: Alignment.center,
                  child: Text(
                    "تسجيل الخروج",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Almarai",
                      color: ColorsModel.ColorsMineLite,
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.03,
                    ),
                  ),
                )),
          ));
  }

  showDialogs(context){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("تنبية",textAlign: TextAlign.right,),
            content: Text("هل تريد تسجيل الخروج",textAlign: TextAlign.right,style: TextStyle(fontFamily: "Almarai",fontSize:  MediaQuery.of(context).size.width*0.035),),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("الفاء",),
              ),
              TextButton(
                onPressed: () async{
                  GoogleSignIn _googleSignIn = GoogleSignIn(
                    scopes: [
                      'email',
                      'https://www.googleapis.com/auth/drive.file',
                    ],
                  );
                  GoogleSignInAccount? account;
                  account = await _googleSignIn.signIn();
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  await preferences.clear();
                  Navigator.of(context).pushNamedAndRemoveUntil('/LoginScreen', (Route<dynamic> route) => false);
                },
                child: Text("نعم",),
              ),
            ],
          );
        });

  }


}
customCupertinoSwitch(size,isorientation,myText,myIcons,value,onChanged){
  return  Container(
      height: isorientation?size.height * 0.1:size.height * 0.07,
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: Colors.black38,

              )
          )
      ),
      width: double.infinity,
      alignment: Alignment.center,
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween,
            children: [
              SizedBox(
                width: size.width * 0.01,),
              Icon(myIcons,
                color: Colors.black38,),
              Text(myText,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: "Almarai",
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize:isorientation?size.width * 0.02: size.width * 0.04,
                ),
              ),


            ],),
          Row(
              children: [
                CupertinoSwitch(
                  value: value,
                  onChanged: onChanged,
                  trackColor: Colors.grey
                      .shade300,
                  activeColor: Colors.blue,
                ),
              ]),

        ],
      ));
}
customInsideBodyV2(size,isorientation,myText,myText2,myIcons,myIcons2,myTap){
  return Container(

      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: Colors.black38,

              )
          )
      ),
      alignment: Alignment.center,
      height: isorientation?size.height * 0.1:size.height * 0.07,
      child: InkWell(onTap: myTap
        , child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween,
              children: [
                Icon(myIcons,
                  color: Colors.black38,),
                SizedBox(width: size.width * 0.01,),
                Container(
                    alignment: Alignment.centerRight,
                    child: Text(myText,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: "Almarai",
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize:isorientation?size.width * 0.02: size.width * 0.04,
                        ))),


              ],),
            Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  Text(
                      myText2,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "Almarai",
                        color: Colors.black26,
                        fontWeight: FontWeight.bold,
                        fontSize:isorientation?size.width * 0.02: size.width * 0.03,
                      )),
                  Icon(
                    myIcons2
                    , color: Colors.black38,
                  ),
                ]),

          ],),));
}
customInsideBody(size,isorientation,myText,myIcons,myTap){
  return InkWell(onTap: myTap,
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: Colors.black38,

                )
            )
        ),
        alignment: Alignment.center,
        height: isorientation?size.height * 0.1:size.height * 0.07,
        child:  Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween,
          children: [
            Row(children: [
              Icon(myIcons, color: Colors.black38,),
              SizedBox(width: size.width * 0.01,),
              Container(
                  alignment: Alignment.centerRight,

                  child: Text(myText,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: "Almarai",
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize:isorientation?size.width * 0.02: size.width * 0.04,
                      ))),

            ],),
            const Icon(
              Icons.arrow_forward_ios_sharp
              , color: Colors.black38,
            ),
          ],),));
}
customInsideBodyV(size,isorientation,myText,myIcons,myIcons2,myTap){
  return InkWell(onTap: myTap,
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: Colors.black38,

                )
            )
        ),
        alignment: Alignment.center,
        height: isorientation?size.height * 0.1:size.height * 0.07,
        child:  Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween,
          children: [
            Row(children: [
              Icon(myIcons, color: Colors.black38,),
              SizedBox(width: size.width * 0.01,),
              Container(
                  alignment: Alignment.centerRight,

                  child: Text(myText,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: "Almarai",
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize:isorientation?size.width * 0.02: size.width * 0.04,
                      ))),

            ],),
            Icon(
              myIcons2
              , color: Colors.black38,
            ),
          ],),));
}

customTitle(size,isorientation,myText){
  return Container(
    height: isorientation?size.height * 0.15:size.height * 0.1,
    width: double.infinity,
    alignment: Alignment.centerRight,
    margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
    padding: EdgeInsets.symmetric(vertical: isorientation?size.height * 0.04:size.height * 0.03),

    child: Text(myText,
      style: TextStyle(
        fontFamily: "Almarai",
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontSize: isorientation?size.width * 0.03:size.width * 0.05,
      ),
    ),);
}
customBody(size,isorientation,myHeight,myColomn){
  return Container(
    margin: EdgeInsets.only(
        left: size.width * 0.01, right: size.width * 0.01),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 7,
          offset: const Offset(0, 3),
        )
      ],
    ),
    padding: EdgeInsets.only(
        left: size.width * 0.02, right: size.width * 0.02),
    height: myHeight,
    alignment: Alignment.center,
    child: myColomn
    ,);
}
