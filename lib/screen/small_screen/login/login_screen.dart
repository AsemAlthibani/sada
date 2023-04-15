import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as UI;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sada/model/color_model.dart';
import 'package:sada/controller/firebase/login_and_register.dart';
import 'package:sada/model/toast_model.dart';
import '../widget/custom_progress_dialog.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreen createState() => _LoginScreen();
}
class _LoginScreen extends State<LoginScreen> {
  var navegtor;
  SharedPreferences? prefs;
  int? ids=1;
  bool passvas=true;
  void initiala() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      ids = prefs?.getInt('FirstLogin');
    });
  }
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    initiala();
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.

    super.dispose();
  }
  var data;

  UI.TextDirection direction = UI.TextDirection.rtl;

 var userimg;

  SharedPreferences? logindata;
  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      userimg = logindata?.getString('id');
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Provider.of<UserController>(context, listen: false);
    final UserController userControllerListen = Provider.of<UserController>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:SingleChildScrollView(
        child:Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                ColorsModel.ColorTherdLite,
                ColorsModel.ColorSecndLite,
              ],
            )
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: size.height*0.04),
              width: size.width,
              height: size.height*0.4,
              child:   Container(
                  width: size.width ,
                  height: size.height * 0.25,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/image/sada2.png'),
                          alignment: Alignment.center
                      )
                  )
              ),
            ),
          Container(
            width: size.width ,
            height: size.height*0.6,
            decoration: BoxDecoration(
              color: Colors.white,
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    ColorsModel.ColorTherdLite,
                    ColorsModel.ColorSecndLite,
                  ],
                ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
            ),
            child:Column(
              children: [
                Text(
                    "صدى",
                    style: TextStyle(
                      fontFamily: "TS-Safaa",
                      color: ColorsModel.ColorsMineLite,
                      fontSize: size.width * 0.06,
                      fontWeight: FontWeight.bold,

                    )),
            Container(
              width: size.width ,
              height: size.height*0.45,
              margin: EdgeInsets.symmetric(
                horizontal: size.width*0.09,
                vertical: size.height*0.01
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: size.width*0.03
              ),
              decoration: BoxDecoration(

                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        ColorsModel.ColorTherdLite,
                        ColorsModel.ColorSecndLite,                      ],
                    ),
                             //color: Colors.white,//(0xff757575),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                      "تسجيل الدخول",
                      style: TextStyle(
                        fontFamily: "TS-Safaa",
                        color:ColorsModel.ColorsMineLite,
                        fontSize: size.width * 0.05,
                      )),
                  _buildTextField(context, size,  "الايميل",userControllerListen.username,false),
                  _buildTextField(context, size, "كلمة المرور", userControllerListen.password,passvas),
                  InkWell(onTap:  ()async{
                    try {
                      bool result = await InternetConnectionChecker().hasConnection;
                      showUpdateProgress(context);
                      if(result){
                        await userController.loginUser(true,context);
                        if(userController.userId!=null){
                          SharedPreferences preferences = await SharedPreferences.getInstance();
                          bool? isAdmin=preferences.getBool("isAdmin");
                          if(isAdmin!){
                            Navigator.pop(context);
                            Navigator.of(context).pushNamedAndRemoveUntil('/AdminMenuScreen', (Route<dynamic> route) => false);
                          }else{
                          Navigator.pop(context);
                          Navigator.of(context).pushNamedAndRemoveUntil('/MenuScreen', (Route<dynamic> route) => false);
                          }
                          userController.restData();
                        }
                      }else{
                        Navigator.pop(context);
                        ToastModel().getToastModel("الرجاء الارتباط بالانترنيت");
                      }
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                    child:
                  Container(
                    width: size.width *0.8,
                    height: size.height * 0.07,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            ColorsModel.ColorsMineLite,
                            ColorsModel.ColorsMineLite,
                          ],),
                        borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: ColorsModel.ColorsMineLite,width: 2)
                    ),
                    child:
                       Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                          fontFamily: "TS-Safaa",
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.034,
                        ),
                      ),
                    ),
                  ),

                ],),)
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildTextField(context, size, hint,textcontrol,obscuretext) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      width: size.width *0.9,
      child: Container(
        alignment: Alignment.center,
        height:size.height*0.08 ,
        width: size.width *0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(44),
        ),
        child: TextField(
          controller: textcontrol,
          obscureText: obscuretext,

          textAlign: TextAlign.center,
          style:  TextStyle(
              fontFamily: "TS-Safaa",
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: size.width *0.035,
          ),
          keyboardType: hint =="الايميل" ? TextInputType.visiblePassword : TextInputType.emailAddress,
          textInputAction: hint == "كلمة المرور" ? TextInputAction.done : TextInputAction.next,

          decoration: InputDecoration(
              isDense: true,
              hoverColor:ColorsModel.ColorsMineLite,
              floatingLabelAlignment:FloatingLabelAlignment.start,
              hintTextDirection:TextDirection.rtl,
              label: Text(
                  hint,
                  style:  TextStyle(
                    fontFamily: "TS-Safaa",
                    color: ColorsModel.ColorsMineLite,
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.034,
                  ),
                  textAlign: TextAlign.center,

              ),

              border: const OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: size.width *0.05,),
              prefixIcon: IconButton(
                alignment: Alignment.center,
                onPressed: () {
                  if(hint !="الايميل"){
                  setState(() {
                    passvas=!passvas;
                  });
                  }
                },
                icon: Icon(hint != "الايميل"?passvas?Icons.visibility_off:Icons.remove_red_eye_outlined:Icons.boy, color: hint != "الايميل" ? ColorsModel.ColorsMineLite : ColorsModel.ColorsMineLite,
                size:  size.width *0.05,
                ),
              ),

              hintStyle: TextStyle(
                  fontFamily: "TS-Safaa",
                color: Colors.grey.shade600,
                  fontSize: size.width *0.035,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                    color: Colors.grey
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                    color: ColorsModel.ColorsMineLite
                ),
                borderRadius: BorderRadius.circular(10),
              )
          ),
        ),
      )
    );
  }

}