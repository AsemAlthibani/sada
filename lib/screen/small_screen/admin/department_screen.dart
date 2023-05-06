import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sada/controller/app_data_controller.dart';
import 'package:sada/screen/small_screen/widget/department_list.dart';
import '../../../controller/task_controller.dart';
import '../../../model/color_model.dart';
import '../../../model/toast_model.dart';
import '../widget/update_task_widget.dart';



class DepartmentScreen extends StatefulWidget {
  @override
  _DepartmentScreen createState() => _DepartmentScreen();
}
class _DepartmentScreen extends State<DepartmentScreen> with TickerProviderStateMixin {
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
    final TaskController taskController = Provider.of<TaskController>(context, listen: false);
    await taskController.getDepartmentFromDb();
}

  @override
  Widget build(BuildContext context) {
    bool isorientation = MediaQuery
        .of(context)
        .orientation == Orientation.landscape;
    Size size = MediaQuery.of(context).size;
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
          "الاقسام",
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
              child:taskControllerListen.departmentList.isNotEmpty?GridView(
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
                  taskControllerListen.departmentList.length,
                      (int index) {
                    final int count = taskControllerListen.departmentList.length;
                    final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animationController!,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn),
                      ),
                    );
                    animationController?.forward();
                    return DepartmentListView(
                        animation: animation,
                        animationController: animationController,
                        itemList: taskControllerListen.departmentList[index],
                        callBack: () {
                          taskController.setDepartment(taskControllerListen.departmentList[index]);
                          updateDepartment(context, size, setState, isorientation,taskControllerListen.departmentList[index].id) ;
                        },callBack2: () {
                          openDepartmentBottomSheet(context,size,taskControllerListen.departmentList[index],index);
                    });
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
            setState((){
              taskController.departmentName.text="";
            });
            showModalBottomSheet(
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
                          child: addDepartment(
                              context, size, setState, isorientation),
                        );
                      },
                    ));
          },
          backgroundColor: ColorsModel.ColorsMineLite,
          child: const Icon(Icons.add)),
    );
  }


  addDepartment(context, size, setState, isorientation) {
    final TaskController taskController = Provider.of<TaskController>(context, listen: false);
    final AppDataController appData = Provider.of<AppDataController>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
          vertical: size.height * 0.01, horizontal: size.width * 0.03),
      child: Column(children: [
        Text(
          "اضافة قسم",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: "TS-Safaa",
              color: Colors.grey.shade800,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "اسم القسم",
              style: TextStyle(
                  fontFamily: "TS-Safaa",
                  color: Colors.grey.shade800,
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold
              ),
            ),Container(
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.02,),
          child:

            myTextField(size,"",taskController.departmentName,Icons.local_fire_department_outlined),

        ) ],),


        Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03,),
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () async {
                      if(taskController.departmentName.text!=""){
                        await taskController.addDepartment(appData.userId);
                        getDepartmentToList();
                        Navigator.pop(context);
                        ToastModel().getToastModel("تمت الاضافة");
                        setState((){
                          taskController.departmentName.text="";
                        });
                      }else{
                        ToastModel().getToastModel("يوجد حقول فارغة");
                      }
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
      ],
      ),
    );
  }


  myTextField(size,eText,myController,eIcons){
    return
          Container(
              width: size.width*0.9 ,
              height: size.height * 0.07,
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

              )
    );
  }

}

