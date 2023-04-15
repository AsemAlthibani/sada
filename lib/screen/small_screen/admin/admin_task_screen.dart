import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sada/controller/employees_controller.dart';
import 'package:sada/model/database_model/task.dart';
import 'package:sada/controller/task_controller.dart';
import 'package:sada/model/color_model.dart';
import 'package:sada/model/toast_model.dart';

import '../../../controller/app_data_controller.dart';
import '../../screen_landing/landing_screen.dart';
import 'admin_menu_screen.dart';



class AdminTaskScreen extends StatefulWidget {
  @override
  _AdminTaskScreen createState() => _AdminTaskScreen();
}
class _AdminTaskScreen extends State<AdminTaskScreen> {

  @override
  void initState() {
    // TODO: implement initState
    final TaskController taskController = Provider.of<TaskController>(context, listen: false);
    final AppDataController appData = Provider.of<AppDataController>(context, listen: false);
    taskController.restData();
    taskController.getTaskAdminToList(appData.userId);
    super.initState();
  }

  int statusColor=1;
  setStatusColor(value){
    setState(() {
      statusColor=value;
    });
  }
  @override
  Widget build(BuildContext context) {
    bool isorientation = MediaQuery.of(context).orientation == Orientation.landscape;
    Size size = MediaQuery.of(context).size;
    final TaskController taskController = Provider.of<TaskController>(context, listen: false);
    final TaskController taskControllerListen = Provider.of<TaskController>(context, listen: true);
    final AppDataController appData = Provider.of<AppDataController>(context, listen: false);
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
          "المهمات المشاركة",
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
      Container(
      width: double.infinity,
      height: size.height*0.07,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: size.width*0.01,vertical: size.height*0.006),
      child:
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child:Row(children:[
          rowButton(size, 'مهام تم الموافقة عليها', Icons.all_inclusive_outlined, 1, ()async{
            setStatusColor(1);
            taskController.setType(1);
            await taskController.getTaskAdminToList(appData.userId);
            }),
          rowButton(size, 'مهام لم يتم الموافقة عليها', Icons.all_inclusive_outlined, 2, ()async{
            setStatusColor(2);
            taskController.setType(2);
            await taskController.getTaskAdminToList(appData.userId);
          }),
        ]))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    dateTimeRangePicker(size);
                    },
                  child: const Icon(Icons.date_range
                  ),),
                Container(
                    width: size.width*0.9,
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
                        itemCount: taskControllerListen.taskList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                              onTap: () async {
                                print(taskControllerListen.taskList[index].online_id);
                                taskController.setUpdateData(taskControllerListen.taskList[index],index);
                                pushToScreen(context,const TaskDetailsScreenLanding(adminShare:true));
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
                                key: ValueKey<int>(taskControllerListen.taskList[index].id),
                                onDismissed: (DismissDirection direction) async {
                                  try {
                                    return showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('هل تريد حذف المهمة',
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
                                                await taskController.deleteTask(taskControllerListen.taskList[index].id);
                                                taskControllerListen.taskList.remove(
                                                    taskControllerListen.taskList[index]);
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
                                      leading: InkWell(
                                        onTap: (){
                                          taskController.updateTaskCompleted(taskControllerListen.taskList[index]);
                                          setState(() {
                                            taskControllerListen.taskList[index].task_completed=1;
                                          });
                                        },
                                        child:Container(
                                          height: size.height*0.07,
                                          width: size.height*0.07,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: taskControllerListen.taskList[index].task_completed==1?ColorsModel.ColorsMineLite:
                                            ColorsModel.ColorsWhite,
                                            border: Border.all(color: ColorsModel.ColorsMineLite,width: taskControllerListen.taskList[index].task_completed==1?0:1
                                            )
                                          ),
                                          child: Icon(
                                            Icons.done_outlined,
                                            color: taskControllerListen.taskList[index].task_completed==1?ColorsModel.ColorsWhite:ColorsModel.ColorsMineLite,
                                            size:  size.height*0.04,
                                          ),
                                        ) ,),
                                      title: Text(taskControllerListen.taskList[index].task_name,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: isorientation ? size
                                                .width * 0.02 : size.width *
                                                0.045,
                                            fontFamily: "odin-next-lt-w23"),),
                                      subtitle: Text(
                                        taskControllerListen.taskList[index].completion_rate.toString(),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade300,
                                            fontSize: isorientation ? size
                                                .width * 0.015 : size.width *
                                                0.04,
                                            fontFamily: "odin-next-lt-w23"),),
                                    )
                                ),
                              ));
                        },
                      ))

          ],
        ),
      ),

         );
  }

  dateTimeRangePicker(size) async {
    DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
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
                    primary: ColorsModel.ColorsMineLite, // button text color
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
                          maxWidth:size.width*0.8,
                          maxHeight: size.height*0.65,
                        ),
                        child: child,
                      )
                    ],
                  ),
                ],
              )
          );
        });
    if(picked!=null){
    }
    print(picked);
  }
  rowButton(size,myText,myIcon,index,onTap){
    return InkWell(
        onTap:onTap ,
        child:  Container(
      height: size.height*0.08,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: size.width*0.005),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color:ColorsModel.ColorsMineLite,width: 2 ),
        gradient: LinearGradient(
          begin: Alignment.center, colors:statusColor==index? [
          ColorsModel.ColorsMineLite,  ColorsModel.ColorsMineLite]:[
          ColorsModel.ColorsWhite,  ColorsModel.ColorsWhite],
        ),                                 ),
      padding: EdgeInsets.symmetric(horizontal: size.width*0.015),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(myIcon,
              color:   statusColor==index?Colors.white:ColorsModel.ColorsMineLite,),
            SizedBox(width: size.width*0.015,),
            Text(
              myText,
              style: TextStyle(
                  fontFamily: "TS-Safaa",
                  color: statusColor==index?Colors.white:ColorsModel.ColorsMineLite,
                  fontSize: size.height * 0.02,
                  fontWeight: FontWeight.w600
              ),
            ),
          ]),
    )
    );
  }
}

