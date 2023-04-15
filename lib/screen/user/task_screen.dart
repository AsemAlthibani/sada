import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sada/controller/employees_controller.dart';
import 'package:sada/model/database_model/task.dart';

import '../../controller/task_controller.dart';
import '../../model/color_model.dart';
import '../../model/toast_model.dart';



class TaskScreen extends StatefulWidget {
  int? type;
  final userId;
  TaskScreen({this.type,this.userId});
  @override
  _TaskScreen createState() => _TaskScreen();
}
class _TaskScreen extends State<TaskScreen> {

  List<Task> taskList =[];
  List<Task> _taskList =[];
  @override
  void initState() {
    // TODO: implement initState
    getTaskToList();
    super.initState();
  }

  getTaskToList()async{
    final EmployeesController employeesController = Provider.of<EmployeesController>(context, listen: false);
    taskList =await employeesController.getTaskTypeFromDb(widget.type,widget.userId);
    setState(() {
      _taskList=taskList;
    });
}

  @override
  Widget build(BuildContext context) {
    bool isorientation = MediaQuery.of(context).orientation == Orientation.landscape;
    Size size = MediaQuery.of(context).size;
    final TaskController taskController = Provider.of<TaskController>(context, listen: false);
    final TaskController taskControllerListen = Provider.of<TaskController>(context, listen: true);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                        itemCount: _taskList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                              onTap: () async {
                                print(_taskList[index].create_by);
                                taskController.setUpdateData(_taskList[index]);
                                showModalBottomSheet(
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
                                              child: updateTask(
                                                  context, size, setState, _taskList[index].id),
                                            );
                                          },
                                        ));
                                },
                              child: Dismissible(
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: ColorsModel.ColorTherdLite,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Icon(Icons.delete_forever),
                                ),
                                key: ValueKey<int>(_taskList[index].id),
                                onDismissed: (DismissDirection direction) async {
                                  try {
                                    return showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('هل تريد حذف المهمة',
                                            textAlign: TextAlign.right,),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('الغاء'),
                                            ),
                                            TextButton(
                                              onPressed: () async {

                                                _taskList.remove(
                                                    _taskList[index]);
                                                Navigator.pop(context);
                                              },
                                              child: Text('موافق'),
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
                                      contentPadding: EdgeInsets.all(8.0),
                                      leading: InkWell(
                                        onTap: (){
                                          taskController.updateTaskCompleted(_taskList[index].id);
                                          setState(() {
                                            _taskList[index].task_completed=1;
                                          });
                                        },
                                        child:Container(
                                          height: size.height*0.07,
                                          width: size.height*0.07,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: _taskList[index].task_completed==1?ColorsModel.ColorsMineLite:
                                            ColorsModel.ColorsWhite,
                                            border: Border.all(color: ColorsModel.ColorsMineLite,width: _taskList[index].task_completed==1?0:1
                                            )
                                          ),
                                          child: Icon(
                                            Icons.done_outlined,
                                            color: _taskList[index].task_completed==1?ColorsModel.ColorsWhite:ColorsModel.ColorsMineLite,
                                            size:  size.height*0.04,
                                          ),
                                        ) ,),
                                      title: Text(_taskList[index].task_name,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: isorientation ? size
                                                .width * 0.02 : size.width *
                                                0.045,
                                            fontFamily: "odin-next-lt-w23"),),
                                      subtitle: Text(
                                        _taskList[index].completion_rate.toString(),
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
  updateTask(context, size, setState, id) {
    final TaskController taskController = Provider.of<TaskController>(context, listen: false);
    final TaskController taskControllerListen = Provider.of<TaskController>(context, listen: true);
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
                        await taskController.updateTask(id);
                        Navigator.pop(context);
                        ToastModel().getToastModel("تم التحديث");
                        getTaskToList();
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
                        borderRadius: BorderRadius.circular(25),
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
                          gradient: LinearGradient(
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
                      border: OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
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
                            border: OutlineInputBorder(),
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

}

