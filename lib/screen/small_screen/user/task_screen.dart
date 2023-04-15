import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sada/controller/employees_controller.dart';
import 'package:sada/model/database_model/task.dart';
import 'package:sada/controller/task_controller.dart';
import 'package:sada/model/color_model.dart';
import 'package:sada/model/toast_model.dart';
import 'package:sada/screen/screen_landing/landing_screen.dart';

import '../../../controller/app_data_controller.dart';
import '../widget/task_list.dart';
import 'menu_screen.dart';



class TaskScreen extends StatefulWidget {
  @override
  _TaskScreen createState() => _TaskScreen();
}
class _TaskScreen extends State<TaskScreen> with TickerProviderStateMixin {
  AnimationController? animationController;


  @override
  void initState() {
    // TODO: implement initState
    animationController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    final TaskController taskController = Provider.of<TaskController>(context, listen: false);
    final AppDataController appData = Provider.of<AppDataController>(context, listen: false);
    taskController.restData();
    taskController.getTaskToList(appData.userId);
    print(taskController.type);
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
    final AppDataController appDataListen = Provider.of<AppDataController>(context, listen: true);
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
          "المهام",
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
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                width: double.infinity,
                height: size.height*0.07,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: size.width*0.01,vertical: size.height*0.006),
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child:Row(children:[
                      rowButton(size, 'المهام اللتي انشئتها', Icons.all_inclusive_outlined, 1, ()async{
                        setStatusColor(1);
                        taskController.setType(1);
                        await taskController.getTaskToList(appData.userId);
                      }),
                      rowButton(size, "المهمام الموكلة اليك", Icons.all_inclusive_outlined, 2, ()async{
                        setStatusColor(2);
                        taskController.setType(2);
                        await taskController.getTaskToList(appData.userId);
                      }),
                      rowButton(size, 'المهام اللتي انشئتها لموظف', Icons.all_inclusive_outlined, 3, ()async{
                        setStatusColor(3);
                        taskController.setType(3);
                        await taskController.getTaskToList(appData.userId);
                      }),

                    ]))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    // dateTimeRangePicker(size);
                  },
                  child:Icon(Icons.date_range,
                    size: size.width*0.06,
                  ),),
                Container(
                    width: size.width*0.8,
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
                InkWell(
                  borderRadius:
                  BorderRadius.circular(AppBar().preferredSize.height),
                  child: Icon(
                    appDataListen.multipleTask! ? Icons.dashboard : Icons.view_agenda,
                    size: size.width*0.06,
                  ),
                  onTap: () {
                    appData.setMultipleStateTask();
                  },
                ),
              ],
            ),
            Expanded(
              child:taskControllerListen.taskList.isNotEmpty?GridView(
                padding: const EdgeInsets.only(
                    top: 0, left: 12, right: 12),
                scrollDirection: Axis.vertical,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: appDataListen.multipleTask! ? 2 : 1,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: appDataListen.multipleTask! ?1.3:3.7,
                ),
                children: List<Widget>.generate(
                  taskControllerListen.taskList.length,
                      (int index) {
                    final int count = taskControllerListen.taskList.length;
                    final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animationController!,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn),
                      ),
                    );
                    animationController?.forward();
                    return appDataListen.multipleTask!?TaskListView(
                      animation: animation,
                      animationController: animationController,
                      itemList: taskControllerListen.taskList[index],
                      callBack: () {
                        print(taskControllerListen.taskList[index].create_by);
                        print(taskControllerListen.taskList[index].emp_id);
                        taskController.setUpdateData(taskControllerListen.taskList[index],index);
                        pushToScreen(context,const TaskDetailsScreenLanding(adminShare:false));
                        print(taskControllerListen.taskList[index].online_id);
                      },
                      callBack2: () {
                        taskController.updateTaskCompleted(taskControllerListen.taskList[index]);
                        setState(() {
                          taskControllerListen.taskList[index].task_completed=1;
                        });
                      },
                    ):verticalTaskListView(
                      animation: animation,
                      animationController: animationController,
                      itemList: taskControllerListen.taskList[index],
                      callBack: () {
                        print(taskControllerListen.taskList[index].create_by);
                        print(taskControllerListen.taskList[index].emp_id);
                        taskController.setUpdateData(taskControllerListen.taskList[index],index);
                        pushToScreen(context,const TaskDetailsScreenLanding(adminShare:false));
                        print(taskControllerListen.taskList[index].online_id);
                      },
                      callBack2: () {
                        taskController.updateTaskCompleted(taskControllerListen.taskList[index]);
                        setState(() {
                          taskControllerListen.taskList[index].task_completed=1;
                        });
                      },
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
                ),)

              ,
            )]),

         );
  }
  updateTask(context, size, setState) {
    final TaskController taskController = Provider.of<TaskController>(context, listen: false);
    final TaskController taskControllerListen = Provider.of<TaskController>(context, listen: true);
    final AppDataController appData = Provider.of<AppDataController>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
          vertical: size.height * 0.01, horizontal: size.width * 0.03),
      child: Column(children: [
        Text(
          "تعديل المهمة",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: "TS-Safaa",
              color: Colors.grey.shade800,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold
          ),
        ),

        myTextField(size,"المهمة",taskController.name,Icons.drive_file_rename_outline),
        myTextField(size,"وصف المهمة",taskController.description,Icons.description_outlined),
        myTextFieldDate(size,"ناريخ بدأ المهمة",taskController.startDate,Icons.date_range),
        myTextFieldDate(size,"تاريخ انتهاء المهمة",taskController.endDate,Icons.start),
        myTextFieldS(size,"نسبه الانجاز",taskController.pitsenteg,Icons.start,taskControllerListen.currentSliderValue),
        Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03,),
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () async {
                        await taskController.updateTask();
                        Navigator.pop(context);
                        ToastModel().getToastModel("تم التحديث");
                        taskController.getTaskToList(appData.userId);
                    },
                    child: Container(
                      height: size.height * 0.07,
                      width: size.width * 0.42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.bottomCenter, colors: [
                          ColorsModel.ColorsMineLite,  ColorsModel.ColorsMineLite],
                        ),
                        borderRadius: BorderRadius.circular(25),
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
                      setState((){
                        taskController.departmentName.text="";
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: size.height * 0.07,
                      width: size.width * 0.42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter, colors: [
                            ColorsModel.ColorsWhite,  ColorsModel.ColorsWhite],
                          ),
                          borderRadius: BorderRadius.circular(25),
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
            )
        ),
      ],),
    );
  }



  myTextField(size,eText,myController,eIcons){
    return  SizedBox(
      width: size.width,
      height: size.height*0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.0),
              width: size.width * 0.23,
              alignment: Alignment.center,
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
              width: size.width * 0.7,
              height: size.height * 0.08,
              margin: EdgeInsets.only(top: size.height * 0.01,bottom: size.height * 0.01),
              decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color:  ColorsModel.ColorsMineLite)
              ),
              child:
              TextField(
                  controller:myController ,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: ColorsModel.ColorsMineLite,
                    fontWeight: FontWeight.w500,
                    fontSize: size.width * 0.035,
                    fontFamily: "TS-Safaa",
                  ),
                  decoration: InputDecoration(
                      isDense: true,
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: size.width *0.05,horizontal: size.width *0.02),
                      suffixIcon: IconButton(
                        alignment: Alignment.center,
                        onPressed: () {

                        },
                        icon: Icon(eIcons,
                          color:ColorsModel.ColorsMineLite,
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
                  )

              )),

        ],),
    );
  }

  myTextFieldDate(size,eText,myController,eIcons){
    return  SizedBox(
      width: size.width,
      height: size.height*0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: size.width * 0.23,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: size.width*0.0),
              child:
              Text(
                eText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: size.width * 0.04,
                  fontFamily: "TS-Safaa",

                ),
              )),
          Container(
            width: size.width * 0.7,
            height: size.height * 0.08,
            margin: EdgeInsets.only(top: size.height * 0.01,bottom: size.height * 0.01),
            decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color:  ColorsModel.ColorsMineLite)
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
                  border: const OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: size.width *0.05,horizontal: size.width *0.02),
                  suffixIcon: IconButton(
                    alignment: Alignment.center,
                    onPressed: () {

                    },
                    icon: Icon(eIcons,
                      color:ColorsModel.ColorsMineLite,
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
                                      maxWidth:size.width,
                                      maxHeight: size.height*0.75,
                                    ),
                                    child: child,
                                  )
                                ],
                              ),],)
                      );
                    });

                if (pickedDate != null) {
                  myController.text =DateFormat('yyyy-MM-dd').format(pickedDate).toString();
                }
              },
            ),
          ),

        ],),
    );
  }
  myDropList(size,isorientation,List<String> CategoriesList,String CategoriesValue,nChanged,categories){
    return  SizedBox(
        width: size.width,
        height: size.height*0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.center,
              child:
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColorsModel.ColorsMineLite, width: 1.3)

                  ),
                  width: size.width * 0.7,
                  height: size.height * 0.08,
                  alignment: Alignment.center,

                  child: DropdownButton(
                      value: CategoriesValue,
                      underline: Container(),
                      borderRadius: BorderRadius.circular(10),
                      dropdownColor:Colors.grey.shade300,
                      icon: const Icon(Icons.keyboard_arrow_down,color: Color(0xffC8D4E3),),
                      items:CategoriesList.map((String occasions) {
                        return DropdownMenuItem<String>(
                            value: occasions,
                            child: Container(width: size.width*0.8,alignment: Alignment.center,
                                child:Text(occasions,style: TextStyle(fontFamily: "TS-Safaa",
                                  color: Colors.black,
                                  fontSize: isorientation ?size
                                      .width * 0.015:size
                                      .width * 0.04,))
                            ));
                      }
                      ).toList(),
                      onChanged: nChanged
                  )
              )
              ,

            ),    Container(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.0),
                width: size.width * 0.23,
                alignment: Alignment.center,
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


          ],
        ));
  }

  myTextFieldS(size,eText,myController,eIcons,_currentSliderValue){
    final TaskController taskControllerListen = Provider.of<TaskController>(context, listen: true);
    return  SizedBox(
        width: size.width,
        height: size.height*0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
                width: size.width * 0.23,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: size.width*0.0),
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
            Row(
              children: [
                Container(
                    width: size.width*0.25 ,
                    height: size.height * 0.08,
                    margin: EdgeInsets.only(top: size.height * 0.01,bottom: size.height * 0.01),
                    decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color:  ColorsModel.ColorsMineLite)
                    ),
                    child:
                    TextField(
                        controller:myController ,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: ColorsModel.ColorsMineLite,
                          fontWeight: FontWeight.w500,
                          fontSize: size.width * 0.035,
                          fontFamily: "TS-Safaa",
                        ),
                        onChanged: (value) {
                          bool a = true;
                          try {
                            double.parse(value);
                          } on FormatException {
                            setState(() {
                              a = false;
                            });
                          } finally {
                            if (a) {
                              if(double.parse(value)>100){
                                taskControllerListen.setSliderValue(100);
                              }else{
                                  taskControllerListen.setSliderValue(value);
                              }
                            }
                          }
                        },
                        decoration: InputDecoration(
                            isDense: true,
                            hintText: _currentSliderValue.toString(),
                            border: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: size.width *0.05,),
                            suffixIcon: IconButton(
                              alignment: Alignment.center,
                              onPressed: () {

                              },
                              icon: Icon(eIcons,
                                color:ColorsModel.ColorsMineLite,
                                size:  size.width *0.05,
                              ),
                            ),

                            hintStyle: TextStyle(
                              color: ColorsModel.ColorsMineLite,
                              fontWeight: FontWeight.w500,
                              fontSize: size.width * 0.035,
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
                        )

                    )),
                SizedBox(
                  width: size.width*0.45,
                  child: Slider(
                    value: _currentSliderValue,
                    max: 100,
                    divisions: 100,
                    activeColor:ColorsModel.ColorsMineLite,
                    inactiveColor:ColorsModel.ColorTherdLite,
                    thumbColor:ColorsModel.ColorsMineLite,
                    label: _currentSliderValue.round().toString(),
                    onChanged: (double value) {
                      taskControllerListen.setSliderValue(value);
                      setState(() {
                        myController.text="";
                      });
                    },
                  ),
                ),
              ],),
          ],)
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
                  ),],)
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
    ));

  }
}

