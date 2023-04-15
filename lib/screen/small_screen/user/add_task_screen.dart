import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sada/controller/app_data_controller.dart';
import 'package:sada/controller/task_controller.dart';
import 'package:sada/model/color_model.dart';
import 'package:sada/model/toast_model.dart';



class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreen createState() => _AddTaskScreen();
}
class _AddTaskScreen extends State<AddTaskScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    bool isorientation= MediaQuery.of(context).orientation == Orientation.landscape;
    Size size = MediaQuery.of(context).size;
    final TaskController taskController = Provider.of<TaskController>(context, listen: false);
    final TaskController taskControllerListen = Provider.of<TaskController>(context, listen: true);
    final AppDataController appData = Provider.of<AppDataController>(context, listen: true);
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
            "مهمة جديدة",
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
    width: size.width ,
    alignment: Alignment.center,
    margin: EdgeInsets.symmetric(horizontal: size.width*0.03,vertical: size.height*0.01),
    child: Column(children: [
      myTextField(size,"المهمة",taskController.name,Icons.drive_file_rename_outline),
      myTextField(size,"وصف المهمة",taskController.description,Icons.description_outlined),
      myTextFieldDate(size,"ناريخ بدأ المهمة",taskController.startDate,Icons.date_range),
      myTextFieldDate(size,"تاريخ انتهاء المهمة",taskController.endDate,Icons.start),

                      SizedBox(height: size.height*0.02,),
      myDropList(size, isorientation, taskController.allEmployees, taskControllerListen.employeesName!, (String? newValue){
        taskController.setEmployName(newValue);
      }, "منفذ المهمة"),
      SizedBox(height: size.height*0.02,),
      myTextFieldS(size,"نسبه الانجاز",taskController.pitsenteg,Icons.start),
    ])),

                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      SizedBox(
                          width: size.width ,
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                  onTap: () async {
                                    setState(() {
                                      taskController.pitsenteg.text=_currentSliderValue.toString();
                                    });
                                    if(taskControllerListen.name.text!="" && taskControllerListen.description.text!="" &&
                                        taskControllerListen.startDate.text!="" && taskControllerListen.endDate.text!="" &&taskControllerListen.pitsenteg.text!=""  ){
                                     await taskController.addTask( Provider.of<AppDataController>(context, listen: false).userId);
                                     if(appData.isAdmin!){
                                     Navigator.of(context).pushNamedAndRemoveUntil('/AdminMenuScreen', (Route<dynamic> route) => false);
                                     }else{
                                       Navigator.of(context).pushNamedAndRemoveUntil('/MenuScreen', (Route<dynamic> route) => false);
                                     }
                                     ToastModel().getToastModel("تمت الاضافة");
                                    }else{
                                      ToastModel().getToastModel("يوجد حقول فارغة");
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

                      SizedBox(
                        height: size.height * 0.01,
                      ),
                    ],
                  ),
                )

    );
  }

  myTextFieldS(size,eText,myController,eIcons){
    return  SizedBox(
      width: size.width,
      height: size.height*0.14,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
              width: size.width*0.35 ,
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
                          setState(() {
                            _currentSliderValue=100;
                          });
                        }else{
                        setState(() {
                          _currentSliderValue=double.parse(value);
                        });
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
                width: size.width*0.55,
                child: Slider(
                  value: _currentSliderValue,
                  max: 100,
                  divisions: 100,
                  activeColor:ColorsModel.ColorsMineLite,
                  inactiveColor:ColorsModel.ColorTherdLite,
                  thumbColor:ColorsModel.ColorsMineLite,
                  label: _currentSliderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      myController.text="";
                      _currentSliderValue = value;
                    });
                  },
                ),
              ),
            ],),
        ],)
    );
  }


  myTextField(size,eText,myController,eIcons){
    return  SizedBox(
      width: size.width,
      height: size.height*0.14,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.0),
              child:
              Text(
                eText,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: size.width * 0.04,
                  fontFamily: "TS-Safaa",

                ),
              )),
          Container(
              width: size.width ,
              height: size.height * 0.08,
              margin: EdgeInsets.only(top: size.height * 0.01,bottom: size.height * 0.01),
              decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color:  ColorsModel.ColorsMineLite)
              ),
              child:
              TextField(
                  controller:myController ,
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
      height: size.height*0.14,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.0),
              child:
              Text(
                eText,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: size.width * 0.04,
                  fontFamily: "TS-Safaa",

                ),
              )),
          Container(
            width: size.width ,
            height: size.height * 0.08,
            margin: EdgeInsets.only(top: size.height * 0.01,bottom: size.height * 0.01),
            decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color:  ColorsModel.ColorsMineLite)
            ),
              child:
              TextFormField(
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
        height: size.height*0.13,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.0),
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
                      border: Border.all(color: ColorsModel.ColorsMineLite, width: 1.3)

                  ),
                  height:isorientation ? size
                      .height * 0.08:size
                      .height * 0.07,
                  width: isorientation? size
                      .width * 0.5:size
                      .width * 0.95,
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

            ),

          ],
        ));
  }
}

