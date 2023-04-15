import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sada/controller/task_controller.dart';
import 'package:sada/model/color_model.dart';
import 'package:sada/model/toast_model.dart';
import '../../../controller/app_data_controller.dart';
import '../../../controller/drive_upload_controller.dart';
import 'custom_progress_dialog.dart';

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

      myTextField(size,"المهمة",taskController.name,Icons.drive_file_rename_outline,size.height*0.1),
      myTextField(size,"وصف المهمة",taskController.description,Icons.description_outlined,size.height*0.1),
      myTextFieldDate(size,"ناريخ بدأ المهمة",taskController.startDate,Icons.date_range,context),
      myTextFieldDate(size,"تاريخ انتهاء المهمة",taskController.endDate,Icons.start,context),
      myTextFieldS(size,"نسبه الانجاز",taskController.pitsenteg,Icons.start,taskControllerListen.currentSliderValue,context,setState),
      Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03,),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myCustomButton(size,"حفظ",size.width * 0.42,[
                ColorsModel.ColorsMineLite,  ColorsModel.ColorsMineLite],Colors.white,() async {
                  await taskController.updateTask();
                  Navigator.pop(context);
                  ToastModel().getToastModel("تم التحديث");
                  taskController.getTaskToList(appData.userId);
                }),
              myCustomButton(size,"الغاء",size.width * 0.42,[
                ColorsModel.ColorsWhite,  ColorsModel.ColorsWhite],ColorsModel.ColorsMineLite,(){
                Navigator.pop(context);
              })
            ],
          )
      ),
    ],),
  );
}
showReportsUploaded(context,size){
  return    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(70.0))),
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return SingleChildScrollView(
                child: dataReportsUploaded(context, size, setState),
              );
            },
          ));
}
dataReportsUploaded(context, size, setState) {
  final DriveUploadController driveUpload = Provider.of<DriveUploadController>(context, listen: false);
  final DriveUploadController driveUploadController = Provider.of<DriveUploadController>(context, listen: true);
  final AppDataController appData = Provider.of<AppDataController>(context, listen: false);
  return Container(
    margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom),
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(
        vertical: size.height * 0.01, horizontal: size.width * 0.03),
    child: Column(children: [
      Text(
        "اضافة ابيانات",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: "TS-Safaa",
            color: Colors.grey.shade800,
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold
        ),
      ),
      myTextField(size,"اسم الملف",driveUpload.fileName,Icons.drive_file_rename_outline,size.height*0.1),
      myTextField(size,"ملاحظة",driveUpload.not,Icons.note_add_outlined,size.height*0.2),
      Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03,),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myCustomButton(size,"رفع الملف",size.width * 0.42,[
                ColorsModel.ColorsMineLite,  ColorsModel.ColorsMineLite],Colors.white,() async {
                bool result = await InternetConnectionChecker().hasConnection;
                if(result){
                if(driveUpload.fileName.text!=""){
                  showUpdateProgress(context);
                  await driveUpload.uploadFileToGoogleDrive(context, appData.userId, appData.displayName);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  ToastModel().getToastModel("تم الرفع");
                  await driveUpload.getFileUploaded();
                }else{
                  ToastModel().getToastModel("يوجد حقول فارغة");
                }
                }else{
                  ToastModel().getToastModel("الرجاء الارتباط بالانترنيت");
                }
              }),
              myCustomButton(size,"الغاء",size.width * 0.42,[
                ColorsModel.ColorsWhite,  ColorsModel.ColorsWhite],ColorsModel.ColorsMineLite,(){
                Navigator.pop(context);
              })
            ],
          )
      ),
    ],),
  );
}

adminUpdateTask(context, size, setState) {
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
        "السماح للمهمة",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: "TS-Safaa",
            color: Colors.grey.shade800,
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold
        ),
      ),
      myTextField(size,"ملاحظة",taskController.not,Icons.note_add_outlined,size.height*0.2),
      Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03,),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myCustomButton(size,"حفظ",size.width * 0.42,[
                ColorsModel.ColorsMineLite,  ColorsModel.ColorsMineLite],Colors.white,() async {
                await taskController.updateTask();
                Navigator.pop(context);
                ToastModel().getToastModel("تم التحديث");
                taskController.getTaskToList(appData.userId);
              }),
              myCustomButton(size,"الغاء",size.width * 0.42,[
                ColorsModel.ColorsWhite,  ColorsModel.ColorsWhite],ColorsModel.ColorsMineLite,(){
                Navigator.pop(context);
              })
            ],
          )
      ),
    ],),
  );
}


myTextField(size,eText,myController,eIcons,height){
  return  SizedBox(
    width: size.width,
    height: height,
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
          height: height - size.height * 0.02,
          margin: EdgeInsets.only(top: size.height * 0.01, bottom: size.height * 0.01),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorsModel.ColorsMineLite)
          ),
            child: TextField(
              maxLines: height==size.height*0.2?10:1,
              //wrap text
              autofocus: true,
              textAlignVertical: TextAlignVertical.bottom,
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
                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: size.width * 0.05, horizontal: size.width * 0.02),
                suffixIcon: IconButton(
                  alignment: Alignment.center,
                  onPressed: () {},
                  icon: Icon(
                    eIcons,
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
                  borderSide: const BorderSide(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: ColorsModel.ColorsMineLite),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
           ],),
  );
}

myTextFieldDate(size,eText,myController,eIcons,context){
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

myTextFieldS(size,eText,myController,eIcons,_currentSliderValue,context,setState){
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
dateTimeRangePicker(size,context) async {
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
myTextFieldD(size,eText,myController,height){
  return  Container(
    width: size.width,
    height: height,
    padding: EdgeInsets.symmetric(horizontal: size.width*0.03),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: size.width*0.0),
            width: size.width * 0.22,
            height: height,
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
            width: size.width * 0.72,
            height: height,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: size.height * 0.01,bottom: size.height * 0.01),
            decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color:  ColorsModel.ColorsMineLite)
            ),
            child:Text(myController.toString(),style: TextStyle(
              color: ColorsModel.ColorsMineLite,
              fontWeight: FontWeight.w500,
              fontSize: size.width * 0.035,
              fontFamily: "TS-Safaa",
            ),))

      ],),
  );
}
myCustomButton(size,myText,width,listColors,color,onTap){
  return InkWell(
      onTap: onTap,
      child: Container(
        height: size.height * 0.07,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter, colors: listColors,
            ),
            borderRadius: BorderRadius.circular(61),
            border: Border.all(color: ColorsModel.ColorsMineLite)
        ),
        child: Text(
          myText,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: "TS-Safaa",
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: size.width * 0.045,
          ),
        ),
      ));

}
