import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as UI;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../model/color_model.dart';
import '../../controller/firebase/login_and_register.dart';
import '../../model/toast_model.dart';
import '../widget/custom_progress_dialog.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreen createState() => _SignUpScreen();
}
class _SignUpScreen extends State<SignUpScreen> {
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
                SizedBox(
                  width: size.width*0.4 ,
                  height: size.height*0.25,
                  child:   Container(
                      width: size.width*0.4 ,
                      height: size.height * 0.15,
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
                  height: size.height*0.8,
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
                  child:Column(
                    children: [
                      Text(
                          "انشاء حساب",
                          style: TextStyle(
                            fontFamily: "TS-Safaa",
                            color: ColorsModel.ColorsMineLite,
                            fontSize: size.width * 0.06,
                            fontWeight: FontWeight.bold,

                          )),
                      Container(
                        width: size.width ,
                        height: size.height*0.67,
                        margin: EdgeInsets.symmetric(
                            horizontal: size.width*0.07,
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
                              ColorsModel.ColorSecndLite,
                            ],
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
                            _buildTextField(context, size,  "الاسم",userControllerListen.username,false,Icons.boy),
                            _buildTextField(context, size,  "الصفة",userControllerListen.description,false,Icons.add_box_outlined),
                            _buildTextField(context, size,  "رقم الهاتف",userControllerListen.phone,false,Icons.phone),
                            _buildTextField(context, size,  "الايميل",userControllerListen.email,false,Icons.email_outlined),
                            _buildTextField(context, size, "كلمة المرور", userControllerListen.password,passvas,Icons.visibility_off),
                            InkWell(onTap:  ()async{
                              try {
                                bool result = await InternetConnectionChecker().hasConnection;
                                showUpdateProgress(context);
                                if(result){
                                  await Firebase.initializeApp();
                                  await userController.userSetup(context);
                                  if(userController.isNewUser){
                                    await userController.userSetupData();
                                  }else{
                                    ToastModel().getToastModel("البريد الاليكتروني قيد الاستخدام");
                                }
                                }else{
                                  Navigator.pop(context);
                                  ToastModel().getToastModel("الرجاء الارتباط بالانترنيت");
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
                                }else{
                                  print(e.code);
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
                                  "انشاء حساب",
                                  style: TextStyle(
                                    fontFamily: "TS-Safaa",
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: size.width * 0.03,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                                onTap: (){
                                   userController.signInWithGoogle(context);
                                },child:
                            Container(
                              alignment: Alignment.center,
                              width: size.width *0.8,
                              height: size.height * 0.07,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: ColorsModel.ColorsMineLite,width: 2)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    width:size.height * 0.034,
                                    height: size.height * 0.034,
                                    color: const Color(0xFFC4C4C4).withOpacity(0.0),
                                    child: SvgPicture.string(
                                      // Group 59
                                      '<svg viewBox="1.0 0.0 22.92 22.92" ><path transform="translate(1.0, 0.0)" d="M 22.6936149597168 9.214142799377441 L 21.77065277099609 9.214142799377441 L 21.77065277099609 9.166590690612793 L 11.45823860168457 9.166590690612793 L 11.45823860168457 13.74988651275635 L 17.93386268615723 13.74988651275635 C 16.98913192749023 16.41793632507324 14.45055770874023 18.33318138122559 11.45823860168457 18.33318138122559 C 7.661551475524902 18.33318138122559 4.583295345306396 15.25492572784424 4.583295345306396 11.45823860168457 C 4.583295345306396 7.661551475524902 7.661551475524902 4.583295345306396 11.45823860168457 4.583295345306396 C 13.21077632904053 4.583295345306396 14.80519008636475 5.244435787200928 16.01918983459473 6.324374675750732 L 19.26015281677246 3.083411931991577 C 17.21371269226074 1.176188230514526 14.47633838653564 0 11.45823860168457 0 C 5.130426406860352 0 0 5.130426406860352 0 11.45823860168457 C 0 17.78605079650879 5.130426406860352 22.91647720336914 11.45823860168457 22.91647720336914 C 17.78605079650879 22.91647720336914 22.91647720336914 17.78605079650879 22.91647720336914 11.45823860168457 C 22.91647720336914 10.68996334075928 22.83741569519043 9.940022468566895 22.6936149597168 9.214142799377441 Z" fill="#ffc107" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(2.32, 0.0)" d="M 0 6.125000953674316 L 3.764603137969971 8.885863304138184 C 4.78324031829834 6.363905429840088 7.250198841094971 4.583294868469238 10.13710117340088 4.583294868469238 C 11.88963890075684 4.583294868469238 13.48405265808105 5.244434833526611 14.69805240631104 6.324373722076416 L 17.93901443481445 3.083411693572998 C 15.89257335662842 1.176188111305237 13.15520095825195 0 10.13710117340088 0 C 5.735992908477783 0 1.919254422187805 2.484718799591064 0 6.125000953674316 Z" fill="#ff3d00" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(2.26, 13.78)" d="M 10.20069408416748 9.135653495788574 C 13.16035556793213 9.135653495788574 15.8496036529541 8.003005981445312 17.88286781311035 6.161093711853027 L 14.33654403686523 3.160181760787964 C 13.14749050140381 4.064460277557373 11.69453620910645 4.553541660308838 10.20069408416748 4.55235767364502 C 7.220407009124756 4.55235767364502 4.689855575561523 2.6520094871521 3.736530303955078 0 L 0 2.878881216049194 C 1.896337866783142 6.589632034301758 5.747450828552246 9.135653495788574 10.20069408416748 9.135653495788574 Z" fill="#4caf50" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(12.46, 9.17)" d="M 11.23537635803223 0.04755179211497307 L 10.31241607666016 0.04755179211497307 L 10.31241607666016 0 L 0 0 L 0 4.583295345306396 L 6.475625038146973 4.583295345306396 C 6.023715496063232 5.853105068206787 5.209692478179932 6.962699413299561 4.134132385253906 7.774986743927002 L 4.135851383209229 7.773841857910156 L 7.682177066802979 10.77475357055664 C 7.431241512298584 11.00277233123779 11.45823955535889 8.020766258239746 11.45823955535889 2.291647672653198 C 11.45823955535889 1.523372769355774 11.37917804718018 0.773431122303009 11.23537635803223 0.04755179211497307 Z" fill="#1976d2" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                      width: size.height * 0.034,
                                      height: size.height * 0.034,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    'Google',
                                    style:  TextStyle(
                                      fontFamily: "TS-Safaa",
                                      color: ColorsModel.ColorsMineLite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: size.width * 0.034,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )),
                            InkWell(
                              onTap: (){
                                Navigator.of(context).pushNamedAndRemoveUntil('/LoginScreen', (Route<dynamic> route) => false);
                              },child:  Text(
                                "تسجيل الدخول",
                                style: TextStyle(
                                  fontFamily: "TS-Safaa",
                                  color: ColorsModel.ColorsMineLite,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.045,
                                )),
                            )
                          ],),)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
  Widget _buildTextField(context, size, hint,textcontrol,obscuretext,myIcons) {
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
              color: Colors.grey.shade800,
              fontWeight: FontWeight.bold,
              fontSize: size.width *0.035,
            ),
            keyboardType: hint =="الاسم" ? TextInputType.visiblePassword : TextInputType.emailAddress,
            textInputAction: hint == "كلمة المرور" ? TextInputAction.done : TextInputAction.next,
            decoration: InputDecoration(
                isDense: true,
                hoverColor:ColorsModel.ColorsMineLite,
                floatingLabelAlignment:FloatingLabelAlignment.center,
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
                    if(hint !="الاسم"){
                      setState(() {
                        passvas=!passvas;
                      });
                    }
                  },
                  icon: Icon(hint == "كلمة المرور"?passvas?Icons.visibility_off:Icons.remove_red_eye_outlined:myIcons,
                    color: hint =="كلمة المرور"  ? ColorsModel.ColorsMineLite : ColorsModel.ColorsMineLite,
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
fetchData(BuildContext context) async {
  showDialog(
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (_) {
        return  const Center(
              child: CircularProgressIndicator(
                backgroundColor: ColorsModel.ColorsMineLite,
                color: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(ColorsModel.ColorTherdLite)));
      }
  );
}