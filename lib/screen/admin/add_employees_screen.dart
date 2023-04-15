import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as UI;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../model/color_model.dart';
import '../../controller/app_data_controller.dart';
import '../../controller/employees_controller.dart';
import '../../controller/firebase/login_and_register.dart';
import '../../controller/task_controller.dart';
import '../../model/toast_model.dart';
import '../widget/custom_progress_dialog.dart';


class EmployeesAddScreen extends StatefulWidget {
  @override
  _EmployeesAddScreen createState() => _EmployeesAddScreen();
}
class _EmployeesAddScreen extends State<EmployeesAddScreen> {
  @override
  Widget build(BuildContext context) {
    bool isorientation = MediaQuery
        .of(context)
        .orientation == Orientation.landscape;
    Size size = MediaQuery
        .of(context)
        .size;
    final EmployeesController employeesController = Provider.of<EmployeesController>(
        context, listen: false);
    final EmployeesController employees = Provider.of<EmployeesController>(
        context, listen: true);
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter, colors: [
                  ColorsModel.ColorsMineLite, ColorsModel.ColorsMineLite],
                ),

              ),
            ),
            backgroundColor: ColorsModel.ColorsMineLite,
            title: Text(
              "مهمة جديدة",
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: size.width,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.03,
                      vertical: size.height * 0.01),
                  child: Column(children: [
                    myTextField(size, "الاسم", employeesController.username,
                        Icons.drive_file_rename_outline_sharp),
                    myTextField(size, "الصفة", employeesController.description,
                        Icons.description_outlined),
                    myDropList(size, isorientation, employeesController.allDepartment, employees.departmentName!, (String? newValue){
                      employeesController.setDepartmentName(newValue);
                    }, "القسم"),
                    myTextField(
                        size, "رقم الهاتف", employeesController.phone,
                        Icons.phone),
                    myTextField(
                        size, "الايميل", employeesController.email,
                        Icons.email),
                    myTextField(
                        size, "كلمة المرور", employeesController.password,
                        Icons.password),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            activeColor: ColorsModel.ColorsMineLite,
                            checkColor: ColorsModel.ColorsWhite,
                            hoverColor: Colors.blue,
                            focusColor: Colors.blue,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            value: employees.isAdmin,
                            onChanged: (value) {
                              employeesController.setIsAdmin(value);
                            }
                        ),
                        Text("ادمن",
                            style: TextStyle(
                              fontFamily: "Almarai",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize:isorientation?size.width * 0.02: size.width * 0.04,
                            )),
                      ],)
                  ])),


              SizedBox(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                          onTap: () async {
                            try {
                              bool result = await InternetConnectionChecker().hasConnection;
                              showUpdateProgress(context);
                              if(result){
                                await Firebase.initializeApp();
                                await employeesController.signInWithFirebase();
                                if(employeesController.isNewUser){
                                  await employeesController.userSetupWithFirebase();
                                  await employeesController.addEmployees();
                                  Navigator.pop(context);
                                }else{
                                  Navigator.pop(context);
                                  ToastModel().getToastModel("البريد الاليكتروني قيد الاستخدام");
                                }
                              }else{
                                Navigator.pop(context);
                                ToastModel().getToastModel("الرجاء الارتباط بالانترنيت");
                              }
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          child: Container(
                            height: size.height * 0.07,
                            width: size.width * 0.42,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter, colors: [
                                ColorsModel.ColorsMineLite, ColorsModel
                                    .ColorsMineLite
                              ],
                              ),
                              borderRadius: BorderRadius.circular(61),
                            ),
                            child: Text(
                              "اضافة",
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
                                border: Border.all(
                                    color: ColorsModel.ColorsMineLite)
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

              SizedBox(
                height: size.height * 0.01,
              ),
            ],
          ),
        )

    );
  }



  myTextField(size, eText, myController, eIcons) {
    return SizedBox(
      width: size.width,
      height: size.height * 0.14,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.0),
              child:
              Text(
                eText,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: size.width * 0.04,
                  fontFamily: "TS-Safaa",

                ),
              )),
          Container(
              width: size.width,
              height: size.height * 0.08,
              margin: EdgeInsets.only(
                  top: size.height * 0.01, bottom: size.height * 0.01),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ColorsModel.ColorsMineLite)
              ),
              child:
              TextField(
                  controller: myController,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: ColorsModel.ColorsMineLite,
                    fontWeight: FontWeight.w500,
                    fontSize: size.width * 0.035,
                    fontFamily: "TS-Safaa",
                  ),
                  decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: size.width *0.05,horizontal: size.width *0.03),
                      suffixIcon: IconButton(
                        alignment: Alignment.center,
                        onPressed: () {

                        },
                        icon: Icon(eIcons,
                          color: ColorsModel.ColorsMineLite,
                          size: size.width * 0.05,
                        ),
                      ),

                      hintStyle: TextStyle(
                        fontFamily: "TS-Safaa",
                        color: Colors.grey.shade600,
                        fontSize: size.width * 0.035,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: Colors.grey
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: ColorsModel.ColorsMineLite
                        ),
                        borderRadius: BorderRadius.circular(10),
                      )
                  )

              )),
        ],),
    );
  }

  myTextFieldDate(size, eText, myController, eIcons) {
    return SizedBox(
      width: size.width,
      height: size.height * 0.14,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.0),
              child:
              Text(
                eText,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: size.width * 0.04,
                  fontFamily: "TS-Safaa",

                ),
              )),
          Container(
            width: size.width,
            height: size.height * 0.08,
            margin: EdgeInsets.only(
                top: size.height * 0.01, bottom: size.height * 0.01),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColorsModel.ColorsMineLite)
            ),
            child:
            TextFormField(
              textAlign: TextAlign.right,
              style: TextStyle(
                color: ColorsModel.ColorsMineLite,
                fontWeight: FontWeight.w500,
                fontSize: size.width * 0.035,
                fontFamily: "TS-Safaa",
              ),
              decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: size.width * 0.05,),
                  suffixIcon: IconButton(
                    alignment: Alignment.center,
                    onPressed: () {

                    },
                    icon: Icon(eIcons,
                      color: ColorsModel.ColorsMineLite,
                      size: size.width * 0.05,
                    ),
                  ),

                  hintStyle: TextStyle(
                    fontFamily: "TS-Safaa",
                    color: Colors.grey.shade600,
                    fontSize: size.width * 0.035,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: Colors.grey
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: ColorsModel.ColorsMineLite
                    ),
                    borderRadius: BorderRadius.circular(10),
                  )
              ),
              controller: myController,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2050),
                    builder: (context, child) {
                      return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: ColorsModel.ColorsMineLite,
                              onPrimary: ColorsModel.ColorsWhite,
                              onSurface: ColorsModel.ColorsMineLite,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                primary: ColorsModel
                                    .ColorsMineLite, // button text color
                              ),
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: size.width,
                                      maxHeight: size.height * 0.75,
                                    ),
                                    child: child,
                                  )
                                ],
                              ),
                            ],)
                      );
                    });

                if (pickedDate != null) {
                  myController.text =
                      DateFormat('yyyy-MM-dd').format(pickedDate).toString();
                }
              },
            ),
          ),
        ],),
    );
  }

  myDropList(size, isorientation, List<String> CategoriesList,
      String CategoriesValue, nChanged, categories) {
    return SizedBox(
        width: size.width,
        height: size.height * 0.13,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.0),
                child:
                Text(
                  categories.toString(),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: size.width * 0.04,
                    fontFamily: "TS-Safaa",
                  ),
                )),
            Container(
              alignment: Alignment.center,
              child:
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: ColorsModel.ColorsMineLite, width: 1.3)

                  ),
                  height: isorientation ? size
                      .height * 0.08 : size
                      .height * 0.07,
                  width: isorientation ? size
                      .width * 0.5 : size
                      .width * 0.95,
                  alignment: Alignment.center,

                  child: DropdownButton(
                      value: CategoriesValue,
                      underline: Container(),
                      borderRadius: BorderRadius.circular(10),
                      dropdownColor: Colors.grey.shade300,
                      icon: const Icon(
                        Icons.keyboard_arrow_down, color: Color(0xffC8D4E3),),
                      items: CategoriesList.map((String occasions) {
                        return DropdownMenuItem<String>(
                            value: occasions,
                            child: Container(width: size.width * 0.8,
                                alignment: Alignment.center,
                                child: Text(occasions,
                                    style: TextStyle(fontFamily: "TS-Safaa",
                                      color: Colors.black,
                                      fontSize: isorientation ? size
                                          .width * 0.015 : size
                                          .width * 0.04,))
                            ));
                      }
                      ).toList(),
                      onChanged: nChanged
                  )
              )
              ,

            ),

          ],
        ));
  }
}