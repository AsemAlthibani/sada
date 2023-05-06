import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sada/controller/task_controller.dart';
import 'package:sada/model/color_model.dart';
import '../../../controller/employees_controller.dart';
import '../../../model/toast_model.dart';
import '../widget/update_task_widget.dart';



class UserDetailsScreen extends StatefulWidget {
  @override
  _UserDetailsScreen createState() => _UserDetailsScreen();
}
class _UserDetailsScreen extends State<UserDetailsScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    bool isorientation = MediaQuery.of(context).orientation == Orientation.landscape;
    Size size = MediaQuery.of(context).size;
    final EmployeesController employeesController = Provider.of<EmployeesController>(
        context, listen: false);
    final EmployeesController employees = Provider.of<EmployeesController>(
        context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: ColorsModel.ColorsMineLite,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "بيانات الموظف",
          style: TextStyle(
              fontFamily: "TS-Safaa",
              color: ColorsModel.ColorsMineLite,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.w500
          ),
        ),
        centerTitle: true,
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
      myTextFieldE(
                size, "الايميل", employeesController.email,
                Icons.email),
      myTextFieldE(
                size, "كلمة المرور", employeesController.password,
                Icons.password),            SizedBox(
              height: size.height * 0.02,
            ),
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
        ],),            SizedBox(
                width: size.width ,
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    myCustomButton(size,"تعديل",size.width * 0.42,[
                      ColorsModel.ColorsMineLite,  ColorsModel.ColorsMineLite],Colors.white,() async {
                      if(employeesController.users!=null && employeesController.username!=""){
                        await employeesController.updateEmployees();
                        await employeesController.getEmployeesFromDb();
                        Navigator.pop(context);
                        ToastModel().getToastModel(
                            "تمت النعديل");

                      }else{
                        ToastModel().getToastModel("يوجد حقول فارغة");
                      }
                    }),
                    myCustomButton(size,"رجوع",size.width * 0.42,[
                      ColorsModel.ColorsWhite,  ColorsModel.ColorsWhite],ColorsModel.ColorsMineLite,(){
                      Navigator.pop(context);
                    })
                  ],
                ))

          ],
        ),
      ),
          ],
        ),
      ),
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
  myTextFieldE(size, eText, myController, eIcons) {
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
              margin: EdgeInsets.only(top: size.height * 0.01, bottom: size.height * 0.01),
              padding: EdgeInsets.symmetric(horizontal: size.height * 0.02),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ColorsModel.ColorsMineLite)
              ),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    myController.text,
                    style: TextStyle(
                    color: ColorsModel.ColorsMineLite,
                    fontWeight: FontWeight.w500,
                    fontSize: size.width * 0.035,
                    fontFamily: "TS-Safaa",
                  ),), Icon(eIcons,
                    color: ColorsModel.ColorsMineLite,
                    size: size.width * 0.05,
                  ),
              ],)),
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


