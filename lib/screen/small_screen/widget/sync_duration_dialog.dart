import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sada/controller/app_data_controller.dart';
import 'package:sada/model/toast_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../../language/t_keys.g.dart';
import '../../../model/color_model.dart';
import '../../../workmanager_callback.dart';

class SyncDurationDialog  extends StatefulWidget {

  _SyncDurationDialog  createState() => _SyncDurationDialog();
}

class _SyncDurationDialog  extends State<SyncDurationDialog > {
  bool isChecked1=false;
  bool isChecked2=false;
  bool isChecked3=false;
  bool isChecked4=false;
  bool isChecked5=false;
  int timer1=15;
  int timer2=0;
  int timer3=0;
  int timer4=0;
  int timer5=0;
  SharedPreferences? prefs;
  var  navegtor;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    bool isorientation= MediaQuery.of(context).orientation == Orientation.landscape;
    return SingleChildScrollView(child:getContent(size,isorientation,context));
  }
  getContent(size,isorientation,context){
    final AppDataController appData = Provider.of<AppDataController>(context, listen: true);
    return Container(
      padding: EdgeInsets.all( size.width * 0.02,),
      height:isorientation? size.height * 0.76:size.height * 0.53,
      width: isorientation?size.width*0.5:size.width*0.4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(19.0),
          topRight: Radius.circular(19.0),
          bottomLeft: Radius.circular(19.0),
          bottomRight: Radius.circular(19.0),
        ),
      ),
      alignment: Alignment.center,
      child:Column(
          children: [
            Container(
              alignment: Alignment.center,
              child:

              Text("اختر مدة المزامنة التلقائية",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Almarai",
                  color: ColorsModel.ColorsMineLite,
                  fontWeight: FontWeight.bold,
                  fontSize:MediaQuery.of(context).orientation == Orientation.landscape ?  size.width * 0.02:size.width * 0.04,
                ),
              ),),           SizedBox(height:isorientation?  size.height*0.02:size.height * 0.01 ,),
      Container(
          height:isorientation?  size.height*0.1:size.height*0.07,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                    color: Colors.black38,

                  )
              )
          ),
          width: double.infinity,
          child: Row(
            children: [
            Checkbox(
            checkColor: Colors.white,
            value: isChecked1,
            shape: CircleBorder(),
            onChanged: (bool? value) {
              setState(() {
                isChecked1 = value!;
                isChecked4 = false;
                isChecked5 = false;
                isChecked2 = false;
                isChecked3 = false;
              });
            },
          ),
           Row(
          children: [
            InkWell(
              onTap: (){
                if(timer1<=59){
                  setState(() {
                    timer1++;
                  });}
              },
              child:Container(
                height: isorientation?size.height * 0.06:size.height * 0.04,
                width: isorientation?size.width * 0.05:size.width *0.07,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.3
                    )
                ),
                child: Icon(
                Icons.keyboard_arrow_up_sharp,
                color: Colors.black,
                  size: isorientation?size.width * 0.03:size.width * 0.06,
              ),)
            ),
              Container(
                height: isorientation?size.height * 0.06:size.height * 0.04,
                width: size.width *0.1,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.3
                    )
                ),
                child: TextField(
                  // controller: ,
                  onChanged: (value){
                    bool a=true;
                    try{
                      int.parse(value);
                    } on FormatException {
                      setState(() {
                        a=false;
                      });
                      ToastModel().getToastModel("لا يسمح بإدخال قيمة سالبة او أحرف في السعر");
                    } finally {
                      if(a){
                      setState(() {
                        timer1=int.parse(value);
                      });
                    }}
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Almarai",
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize:isorientation? size.width * 0.017:size.width * 0.03,
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText:timer1.toString(),
                    hintStyle: TextStyle(
                      fontFamily: "Almarai",
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize:isorientation? size.width * 0.017:size.width * 0.03,
                    ),
                    isDense: false,
                  ),
                ),
              ),
            InkWell(
                onTap: (){

                  if(timer1>=16){
                    setState(() {
                      timer1--;
                    });}
                },
                child:Container(
                  height: isorientation?size.height * 0.06:size.height * 0.04,
                  width: isorientation?size.width * 0.05:size.width *0.07,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1.3
                      )
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: Colors.black,
                    size: isorientation?size.width * 0.03:size.width * 0.06,
                  ),)
            ),
          ]),
            Container(
                  height: size.height*0.05,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(

                  ),
                  width:size.width*0.2,
                  child:
                  Text("دقيقة",
                    textAlign: TextAlign.left,
                    style: TextStyle(

                      fontFamily: "Almarai",
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize:MediaQuery.of(context).orientation == Orientation.landscape ?  size.width * 0.02:size.width * 0.03,
                    ),

                ))],)),
             Container(
                 height:isorientation?  size.height*0.1:size.height*0.07,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                              color: Colors.black38,

                            )
                        )
                    ),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: isChecked2,
                          shape: CircleBorder(),
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked2 = value!;
                              isChecked4 = false;
                              isChecked5 = false;
                              isChecked3 = false;
                              isChecked1 = false;
                            });
                          },
                        ),
                        Row(
                            children: [
                              InkWell(
                                  onTap: (){
                                    if(timer2<=23){
                                      setState(() {
                                        timer2++;
                                      });}
                                  },
                                  child:Container(
                                    height: isorientation?size.height * 0.06:size.height * 0.04,
                                    width: isorientation?size.width * 0.05:size.width *0.07,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1.3
                                        )
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_up_sharp,
                                      color: Colors.black,
                                      size: isorientation?size.width * 0.03:size.width * 0.06,
                                    ),)
                              ),
                              Container(
                                height: isorientation?size.height * 0.06:size.height * 0.04,
                                width: size.width *0.1,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1.3
                                    )
                                ),
                                child: TextField(
                                  // controller: ,
                                  onChanged: (value){
                                    bool a=true;
                                    try{
                                      int.parse(value);
                                    } on FormatException {
                                      setState(() {
                                        a=false;
                                      });
                                      ToastModel().getToastModel("لا يسمح بإدخال قيمة سالبة او أحرف في السعر");
                                    } finally {
                                      if(a){
                                      setState(() {
                                        timer2=int.parse(value);
                                      });
                                    }}
                                  },
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Almarai",
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize:isorientation? size.width * 0.017:size.width * 0.03,
                                  ),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    hintText:timer2.toString(),
                                    hintStyle: TextStyle(
                                      fontFamily: "Almarai",
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize:isorientation? size.width * 0.017:size.width * 0.03,
                                    ),
                                    isDense: false,
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: (){
                                    if(timer2>=1){
                                      setState(() {
                                        timer2--;
                                      });}
                                  },
                                  child:Container(
                                    height: isorientation?size.height * 0.06:size.height * 0.04,
                                    width: isorientation?size.width * 0.05:size.width *0.07,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1.3
                                        )
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      color: Colors.black,
                                      size: isorientation?size.width * 0.03:size.width * 0.06,
                                    ),)
                              ),
                            ]),
                        Container(
                          height: size.height*0.05,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(

                          ),
                          width:size.width*0.2,
                          child:
                          Text("ساعة",
                            textAlign: TextAlign.left,
                            style: TextStyle(

                              fontFamily: "Almarai",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize:MediaQuery.of(context).orientation == Orientation.landscape ?  size.width * 0.02:size.width * 0.03,
                            ),
                          ),
                        )],)),
             Container(
                 height:isorientation?  size.height*0.1:size.height*0.07,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                              color: Colors.black38,

                            )
                        )
                    ),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: isChecked3,
                          shape: CircleBorder(),
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked3 = value!;
                              isChecked4 = false;
                              isChecked5 = false;
                              isChecked2 = false;
                              isChecked1 = false;
                            });
                          },
                        ),
                        Row(
                            children: [
                              InkWell(
                                  onTap: (){
                                    if(timer3<=29){
                                      setState(() {
                                        timer3++;
                                      });}
                                  },
                                  child:Container(
                                    height: isorientation?size.height * 0.06:size.height * 0.04,
                                    width: isorientation?size.width * 0.05:size.width *0.07,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1.3
                                        )
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_up_sharp,
                                      color: Colors.black,
                                      size: isorientation?size.width * 0.03:size.width * 0.06,
                                    ),)
                              ),
                              Container(
                                height: isorientation?size.height * 0.06:size.height * 0.04,
                                width: size.width *0.1,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1.3
                                    )
                                ),
                                child: TextField(
                                  // controller: ,
                                  onChanged: (value){
                                    bool a=true;
                                    try{
                                      int.parse(value);
                                    } on FormatException {
                                      setState(() {
                                        a=false;
                                      });
                                      ToastModel().getToastModel("لا يسمح بإدخال قيمة سالبة او أحرف في السعر");

                                    } finally {
                                      if(a){
                                      setState(() {
                                        timer3=int.parse(value);
                                      });
                                    }}
                                  },
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Almarai",
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize:isorientation? size.width * 0.017:size.width * 0.03,
                                  ),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    hintText:timer3.toString(),
                                    hintStyle: TextStyle(
                                      fontFamily: "Almarai",
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize:isorientation? size.width * 0.017:size.width * 0.03,
                                    ),
                                    isDense: false,
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: (){
                                    if(timer3>=1){
                                      setState(() {
                                        timer3--;
                                      });}
                                  },
                                  child:Container(
                                    height: isorientation?size.height * 0.06:size.height * 0.04,
                                    width: isorientation?size.width * 0.05:size.width *0.07,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1.3
                                        )
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      color: Colors.black,
                                      size: isorientation?size.width * 0.03:size.width * 0.06,
                                    ),)
                              ),
                            ]),
                        Container(
                          height: size.height*0.05,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(

                          ),
                          width:size.width*0.2,
                          child:
                          Text("يوم",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: "Almarai",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize:MediaQuery.of(context).orientation == Orientation.landscape ?  size.width * 0.02:size.width * 0.03,
                            ),
                          ),
                        )],)),
             Container(
                 height:isorientation?  size.height*0.1:size.height*0.07,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                              color: Colors.black38,

                            )
                        )
                    ),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: isChecked4,
                          shape: CircleBorder(),
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked4 = value!;
                              isChecked3 = false;
                              isChecked5 = false;
                              isChecked2 = false;
                              isChecked1 = false;
                            });
                          },
                        ),
                        Row(
                            children: [
                              InkWell(
                                  onTap: (){
                                    if(timer4<=3){
                                      setState(() {
                                        timer4++;
                                      });}
                                  },
                                  child:Container(
                                    height: isorientation?size.height * 0.06:size.height * 0.04,
                                    width: isorientation?size.width * 0.05:size.width *0.07,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1.3
                                        )
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_up_sharp,
                                      color: Colors.black,
                                      size: isorientation?size.width * 0.03:size.width * 0.06,
                                    ),)
                              ),
                              Container(
                                height: isorientation?size.height * 0.06:size.height * 0.04,
                                width: size.width *0.1,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1.3
                                    )
                                ),
                                child: TextField(
                                  // controller: ,
                                  onChanged: (value){
                                    bool a=true;
                                    try{
                                      int.parse(value);
                                    } on FormatException {
                                      setState(() {
                                        a=false;
                                      });
                                      ToastModel().getToastModel("لا يسمح بإدخال قيمة سالبة او أحرف في السعر");
                                    } finally {
                                      if(a){
                                      setState(() {
                                        timer4=int.parse(value);
                                      });
                                    }}
                                  },
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Almarai",
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize:isorientation? size.width * 0.017:size.width * 0.03,
                                  ),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    hintText:timer4.toString(),
                                    hintStyle: TextStyle(
                                      fontFamily: "Almarai",
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize:isorientation? size.width * 0.017:size.width * 0.03,
                                    ),
                                    isDense: false,
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: (){
                                    if(timer4>=1){
                                      setState(() {
                                        timer4--;
                                      });}
                                  },
                                  child:Container(
                                    height: isorientation?size.height * 0.06:size.height * 0.04,
                                    width: isorientation?size.width * 0.05:size.width *0.07,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1.3
                                        )
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      color: Colors.black,
                                      size: isorientation?size.width * 0.03:size.width * 0.06,
                                    ),)
                              ),
                            ]),
                        Container(
                          height: size.height*0.05,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(

                          ),
                          width:size.width*0.2,
                          child:
                          Text("اسبوع",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: "Almarai",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize:MediaQuery.of(context).orientation == Orientation.landscape ?  size.width * 0.02:size.width * 0.03,
                            ),
                          ),
                        )],)),
        Container(
            height:isorientation?  size.height*0.1:size.height*0.07,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                              color: Colors.black38,

                            )
                        )
                    ),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: isChecked5,
                          shape: CircleBorder(),
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked5 = value!;
                              isChecked4 = false;
                              isChecked3 = false;
                              isChecked2 = false;
                              isChecked1 = false;
                            });
                          },
                        ),
                        Row(
                            children: [
                              InkWell(
                                  onTap: (){
                                    if(timer5<=11){
                                      setState(() {
                                        timer5++;
                                      });}
                                  },
                                  child:Container(
                                    height: isorientation?size.height * 0.06:size.height * 0.04,
                                    width: isorientation?size.width * 0.05:size.width *0.07,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1.3
                                        )
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_up_sharp,
                                      color: Colors.black,
                                      size: isorientation?size.width * 0.03:size.width * 0.06,
                                    ),)
                              ),
                              Container(
                                height: isorientation?size.height * 0.06:size.height * 0.04,
                                width: size.width *0.1,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1.3
                                    )
                                ),
                                child: TextField(
                                  // controller: ,
                                  onChanged: (value){
                                    bool a=true;
                                    try{
                                      int.parse(value);
                                    } on FormatException {
                                      setState(() {
                                        a=false;
                                      });
                                      ToastModel().getToastModel("لا يسمح بإدخال قيمة سالبة او أحرف في السعر");

                                    } finally {
                                      if(a){
                                      setState(() {
                                        timer5=int.parse(value);
                                      });
                                    }}
                                  },
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Almarai",
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize:isorientation? size.width * 0.017:size.width * 0.03,
                                  ),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    hintText:timer5.toString(),
                                    hintStyle: TextStyle(
                                      fontFamily: "Almarai",
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize:isorientation? size.width * 0.017:size.width * 0.03,
                                    ),
                                    isDense: false,
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: (){
                                    if(timer5>=1){
                                      setState(() {
                                        timer5--;
                                      });}
                                  },
                                  child:Container(
                                    height: isorientation?size.height * 0.06:size.height * 0.04,
                                    width: isorientation?size.width * 0.05:size.width *0.07,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1.3
                                        )
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      color: Colors.black,
                                      size: isorientation?size.width * 0.03:size.width * 0.06,
                                    ),)
                              ),
                            ]),
                        Container(
                          height: size.height*0.05,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(

                          ),
                          width:size.width*0.2,
                          child:
                          Text("شهر",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: "Almarai",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize:MediaQuery.of(context).orientation == Orientation.landscape ?  size.width * 0.02:size.width * 0.03,
                            ),
                          ),
                        )],)),
            SizedBox(height:size.height * 0.02 ,),
            SizedBox(
                width: size.width ,
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                        onTap: () async {
                          prefs=await SharedPreferences.getInstance();
                          if(isChecked1){
                            await Workmanager().cancelByUniqueName(rescheduledTaskKey);
                            await Workmanager().registerPeriodicTask(
                              rescheduledTaskKey,
                              rescheduledTaskKey,
                              frequency:  Duration(minutes: timer1),
                              initialDelay: const Duration(minutes: 1),
                              constraints: Constraints(networkType: NetworkType.connected),
                            );
                            appData.setSyncDuration("$timer1 دقيقة");
                              prefs?.setString("syncDuration", "$timer1 دقيقة");
                              print("$timer1 ");
                            Navigator.pop(context);
                          }else if(isChecked2){
                            await Workmanager().cancelByUniqueName(rescheduledTaskKey);
                            await Workmanager().registerPeriodicTask(
                              rescheduledTaskKey,
                              rescheduledTaskKey,
                              frequency:   Duration(hours: timer2),
                              initialDelay: const Duration(minutes: 1),
                              constraints: Constraints(networkType: NetworkType.connected),
                            );
                            appData.setSyncDuration("$timer2 ساعة");
                              prefs?.setString("syncDuration", "$timer2 ساعة");
                            Navigator.pop(context);
                          }
                          else if(isChecked3){
                            await Workmanager().cancelByUniqueName(rescheduledTaskKey);
                            await Workmanager().registerPeriodicTask(
                              rescheduledTaskKey,
                              rescheduledTaskKey,
                              frequency:  Duration(days: timer3),
                              initialDelay: const Duration(minutes: 1),
                              constraints: Constraints(networkType: NetworkType.connected),
                            );
                            appData.setSyncDuration("$timer3 يوم");
                            prefs?.setString("syncDuration", "$timer3 يوم");
                            Navigator.pop(context);
                          }
                          else if(isChecked4){
                            int a=timer4*7;
                            await Workmanager().cancelByUniqueName(rescheduledTaskKey);
                            await Workmanager().registerPeriodicTask(
                              rescheduledTaskKey,
                              rescheduledTaskKey,
                              frequency: Duration(days: a),
                              initialDelay: const Duration(minutes: 1),
                              constraints: Constraints(networkType: NetworkType.connected),
                            );
                            appData.setSyncDuration("$timer4 اسبوع");
                            prefs?.setString("syncDuration", "$timer4 اسبوع");
                            Navigator.pop(context);
                          }
                          else if(isChecked5){
                            int a=timer5*30;
                            await Workmanager().cancelByUniqueName(rescheduledTaskKey);
                            await Workmanager().registerPeriodicTask(
                              rescheduledTaskKey,
                              rescheduledTaskKey,
                              frequency:  Duration(days: a),
                              initialDelay: const Duration(minutes: 1),
                              constraints: Constraints(networkType: NetworkType.connected),
                            );

                            appData.setSyncDuration("$timer5 شهر");
                            prefs?.setString("syncDuration", "$timer5 شهر");
                            Navigator.pop(context);
                          }else{
                            ToastModel().getToastModel("الرجاء اختيار احدى الاختيارات");

                          }
                        },
                        child: Container(
                          height: size.height * 0.07,
                          width: size.width * 0.42,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter, colors: [
                              ColorsModel.ColorsMineLite,  ColorsModel.ColorsMineLite],
                            ),
                            borderRadius: BorderRadius.circular(61),
                          ),
                          child: Text(
                            "حفظ",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "TS-Safaa",
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: size.width * 0.045,
                            ),
                          ),
                        )),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: size.height * 0.07,
                          width: size.width * 0.42,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(61),
                              border: Border.all(color: ColorsModel.ColorsMineLite)
                          ),
                          child: Text(
                            "الغاء",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "TS-Safaa",
                              color: ColorsModel.ColorsMineLite,
                              fontWeight: FontWeight.w500,
                              fontSize: size.width * 0.045,
                            ),
                          ),
                        )),



                  ],
                )),
          ]),
    );
  }
}
SyncDurations(BuildContext context) {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(70.0))),
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return SingleChildScrollView(
                child: SyncDurationDialog(),
              );
            },
          ));
}