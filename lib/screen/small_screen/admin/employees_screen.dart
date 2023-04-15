import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sada/model/database_model/users.dart';
import 'package:sada/controller/employees_controller.dart';
import 'package:sada/controller/task_controller.dart';
import 'package:sada/model/color_model.dart';
import '../user/menu_screen.dart';
import 'add_employees_screen.dart';



class EmployeesScreen extends StatefulWidget {
  @override
  _EmployeesScreen createState() => _EmployeesScreen();
}
class _EmployeesScreen extends State<EmployeesScreen> {

  List<Users> departmentList =[];
  List<Users> _departmentList =[];
  @override
  void initState() {
    // TODO: implement initState
    getDepartmentToList();
    super.initState();
  }

  getDepartmentToList()async{
    final EmployeesController employeesController = Provider.of<EmployeesController>(context, listen: false);
    departmentList =await employeesController.getEmployeesFromDb();
    setState(() {
      _departmentList=departmentList;
    });
}

  @override
  Widget build(BuildContext context) {
    bool isorientation = MediaQuery
        .of(context)
        .orientation == Orientation.landscape;
    Size size = MediaQuery
        .of(context)
        .size;
    final TaskController taskController = Provider.of<TaskController>(
        context, listen: false);
    final TaskController taskControllerListen = Provider.of<TaskController>(
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
          "الموظفين",
          style: TextStyle(
              fontFamily: "TS-Safaa",
              color: ColorsModel.ColorsMineLite,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.w500
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(
              Icons.notifications,
              size: 30,
              color: ColorsModel.ColorsMineLite,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
            Container(
                height: size.height * 0.82,
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                child:  ListView.builder(
                        itemCount: _departmentList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                              onTap: () async {

                                },
                              child: Dismissible(
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: ColorsModel.ColorTherdLite,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: const Icon(Icons.delete_forever),
                                ),
                                key: ValueKey<int>(_departmentList[index].id),
                                onDismissed: (DismissDirection direction) async {
                                  try {
                                    return showDialog(

                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('هل تريد حذف الطابعة',
                                            textAlign: TextAlign.right,),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('الغاء'),
                                            ),
                                            TextButton(
                                              onPressed: () async {

                                                _departmentList.remove(
                                                    _departmentList[index]);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('موافق'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                  catch (e) {
                                    print(e);
                                  }
                                },
                                child: Card(
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(8.0),
                                      title: Text(_departmentList[index].user_name,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: isorientation ? size
                                                .width * 0.02 : size.width *
                                                0.045,
                                            fontFamily: "odin-next-lt-w23"),),
                                    )
                                ),
                              ));
                        },
                      ))

          ],
        ),
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

