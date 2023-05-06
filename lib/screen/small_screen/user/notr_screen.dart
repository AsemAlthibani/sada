import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sada/controller/task_controller.dart';
import 'package:sada/model/color_model.dart';

import '../../../controller/app_data_controller.dart';
import '../../screen_landing/landing_screen.dart';
import '../widget/note_list.dart';
import '../widget/update_task_widget.dart';
import 'menu_screen.dart';



class NoteScreen extends StatefulWidget {
  @override
  _NoteScreen createState() => _NoteScreen();
}
class _NoteScreen extends State<NoteScreen> with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    // TODO: implement initState
    animationController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    final TaskController taskController = Provider.of<TaskController>(context, listen: false);
    final AppDataController appData = Provider.of<AppDataController>(context, listen: false);
    taskController.restType();
    taskController.getAdminNoteToList(appData.userId);
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
    Size size = MediaQuery.of(context).size;
    final TaskController taskController = Provider.of<TaskController>(context, listen: false);
    final TaskController taskControllerListen = Provider.of<TaskController>(context, listen: true);
    final AppDataController appDataListen = Provider.of<AppDataController>(context, listen: true);
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
          "الملاحظات",
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
      Container(
      width: double.infinity,
      height: size.height*0.07,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: size.width*0.01,vertical: size.height*0.006),
      child:
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child:Row(children:[
          rowButton(size, 'ملاحظات المهام', Icons.all_inclusive_outlined, 1, ()async{
            setStatusColor(1);
            taskController.setType(1);
            await taskController.getAdminNoteToList(appData.userId);
            }),
          rowButton(size, 'ملاحظات التقارير', Icons.all_inclusive_outlined, 2, ()async{
            setStatusColor(2);
            taskController.setType(2);
            await taskController.getAdminNoteToList(appData.userId);
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
                      onChanged: taskController.taskFilter,
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
              child:taskControllerListen.noteList.isNotEmpty?GridView(
                padding: const EdgeInsets.only(
                    top: 0, left: 12, right: 12),
                scrollDirection: Axis.vertical,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: appDataListen.multipleTask! ? 2 : 1,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: appDataListen.multipleTask! ?1.6:4,
                ),
                children: List<Widget>.generate(
                  taskControllerListen.noteList.length,
                      (int index) {
                    final int count = taskControllerListen.noteList.length;
                    final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animationController!,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn),
                      ),
                    );
                    animationController?.forward();
                    return appDataListen.multipleTask!?noteListView(
                      animation: animation,
                      animationController: animationController,
                      itemList: taskControllerListen.noteList[index],
                      callBack: () async{
                        await taskController.setNoteTask(taskControllerListen.noteList[index],taskControllerListen.type);
                        showAdminNoteTask(context, size, setState);
                      },
                    ):verticalnoteListView(
                      animation: animation,
                      animationController: animationController,
                      itemList: taskControllerListen.noteList[index],
                      callBack: () async{
                        await taskController.setNoteTask(taskControllerListen.noteList[index],taskControllerListen.type);
                        if(taskController.type==1){
                          showAdminNoteTask(context, size, setState);
                        }else{
                          showAdminNoteReportsUploaded(context, size, setState);
                        }
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
            )
          ],
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

