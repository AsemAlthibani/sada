import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sada/model/database_model/users.dart';
import 'package:sada/controller/employees_controller.dart';
import 'package:sada/controller/task_controller.dart';
import 'package:sada/model/color_model.dart';
import 'package:sada/screen/small_screen/admin/user_details_screen.dart';
import '../user/menu_screen.dart';
import '../widget/update_task_widget.dart';
import '../widget/users_list.dart';
import 'add_employees_screen.dart';



class EmployeesScreen extends StatefulWidget {
  @override
  _EmployeesScreen createState() => _EmployeesScreen();
}
class _EmployeesScreen extends State<EmployeesScreen> with TickerProviderStateMixin {
  AnimationController? animationController;


  @override
  void initState() {
    // TODO: implement initState
    getDepartmentToList();
    super.initState();
  }

  getDepartmentToList()async{
    animationController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    final EmployeesController employeesController = Provider.of<EmployeesController>(context, listen: false);
    await employeesController.getEmployeesFromDb();
}

  @override
  Widget build(BuildContext context) {
    bool isorientation = MediaQuery
        .of(context)
        .orientation == Orientation.landscape;
    Size size = MediaQuery
        .of(context)
        .size;
    final EmployeesController employeesController = Provider.of<EmployeesController>(context, listen: false);
    final EmployeesController employees = Provider.of<EmployeesController>(context, listen: true);
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
          "الموظفين",
          style: TextStyle(
              fontFamily: "TS-Safaa",
              color: ColorsModel.ColorsMineLite,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.w500
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    width: size.width*0.95,
                    height: size.height * 0.06,
                    margin: EdgeInsets.only(top: size.height * 0.01,bottom: size.height * 0.01),
                    child:
                    TextField(
                      onChanged: employeesController.departmentFilter,
                      decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.symmetric(vertical: size.width * 0.02, horizontal: size.width * 0.05),
                        hintText: "Search",
                        suffixIcon: const Icon(Icons.search),
                        // prefix: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(),
                        ),
                      ),
                    )),
                 ],
            ),
            Expanded(
              child:employees.employeesList.isNotEmpty?GridView(
                padding: const EdgeInsets.only(
                    top: 0, left: 12, right: 12),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:  1,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: 6,
                ),
                children: List<Widget>.generate(
                  employees.employeesList.length,
                      (int index) {
                    final int count = employees.employeesList.length;
                    final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animationController!,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn),
                      ),
                    );
                    animationController?.forward();
                    return UsersListView(
                        animation: animation,
                        animationController: animationController,
                        itemList: employees.employeesList[index],
                        callBack: () {
                          employeesController.setUpdateData(employees.employeesList[index]);
                          pushToScreen(context, UserDetailsScreen());
                        },callBack2: () {
                      openUserBottomSheet(context,size,employees.employeesList[index],index);
                    }
                        );
                  },
                ),
              ):
              Container(
                height: size.height,
                width: size.width,
                alignment: Alignment.center,
                child: Text(
                  "لايوجد بيانات",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily:"TS-Safaa",
                      color: Colors.grey.shade800,
                      fontSize: size.width * 0.06,
                      fontWeight: FontWeight.w500),
                ),),
            )

          ],
        ),

      floatingActionButton:
      FloatingActionButton(
          tooltip: 'Increment',
          onPressed: () {
            final EmployeesController employeesController = Provider.of<EmployeesController>(context, listen: false);
            employeesController.getAllDepartment();
            pushToScreen(context,EmployeesAddScreen());
          },
          backgroundColor: ColorsModel.ColorsMineLite,
          child: const Icon(Icons.add)),
    );
  }



}

