import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sada/controller/task_controller.dart';
import 'package:sada/model/color_model.dart';
import '../widget/update_task_widget.dart';



class TaskDetailsScreen extends StatefulWidget {
  bool? adminShare;
  TaskDetailsScreen({this.adminShare});
  @override
  _TaskDetailsScreen createState() => _TaskDetailsScreen();
}
class _TaskDetailsScreen extends State<TaskDetailsScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    bool isorientation = MediaQuery.of(context).orientation == Orientation.landscape;
    Size size = MediaQuery.of(context).size;
    final TaskController taskController = Provider.of<TaskController>(context, listen: false);
    final TaskController taskControllerListen = Provider.of<TaskController>(context, listen: true);

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
          "تفاصيل المهمة",
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
            myTextFieldD(size,"اسم المهمة",taskController.nameDetails.text,size.height*0.1),
            myTextFieldD(size,"وصف المهمة",taskController.descriptionDetails.text,size.height*0.2),
            myTextFieldD(size,"منشئ المهمة",taskController.createByNameDetails.text,size.height*0.1),
            myTextFieldD(size,"الموكل بالمهمة",taskController.empNameDetails.text,size.height*0.1),
            myTextFieldD(size,"تاريخ البداء",taskController.startDateDetails.text,size.height*0.1),
            myTextFieldD(size,"تاريخ الانتهاء",taskController.endDateDetails.text,size.height*0.1),
            myTextFieldD(size,"نسبه الانجاز",taskController.currentSliderValueDetails,size.height*0.1),
            SizedBox(
              height: size.height * 0.02,
            ),
            widget.adminShare!?taskControllerListen.type==1?SizedBox(
                width: size.width,
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    myCustomButton(size,"السماح",size.width * 0.42,[
                      ColorsModel.ColorsMineLite,  ColorsModel.ColorsMineLite],Colors.white,() async {
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
                                    child: adminUpdateTask(
                                        context, size, setState),
                                  );
                                },
                              ));
                    }),
                    myCustomButton(size,"رجوع",size.width * 0.42,[
                      ColorsModel.ColorsWhite,  ColorsModel.ColorsWhite],ColorsModel.ColorsMineLite,(){
                      Navigator.pop(context);
                    })


                  ],
                )):myCustomButton(size,"رجوع",size.width * 0.84,[
              ColorsModel.ColorsWhite,  ColorsModel.ColorsWhite],ColorsModel.ColorsMineLite,(){
              Navigator.pop(context);
            }):taskControllerListen.type==1 || taskControllerListen.type==2?SizedBox(
                width: size.width ,
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    myCustomButton(size,"تعديل",size.width * 0.42,[
                      ColorsModel.ColorsMineLite,  ColorsModel.ColorsMineLite],Colors.white,() async {
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
                                        context, size, setState),
                                  );
                                },
                              ));
                    }),
                    myCustomButton(size,"رجوع",size.width * 0.42,[
                      ColorsModel.ColorsWhite,  ColorsModel.ColorsWhite],ColorsModel.ColorsMineLite,(){
                      Navigator.pop(context);
                    })
                  ],
                )):myCustomButton(size,"رجوع",size.width * 0.84,[
              ColorsModel.ColorsWhite,  ColorsModel.ColorsWhite],ColorsModel.ColorsMineLite,(){
              Navigator.pop(context);
            }),

          ],
        ),
      ),

    );
  }

}

