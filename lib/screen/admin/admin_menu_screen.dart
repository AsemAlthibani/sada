import 'package:flutter/material.dart' hide Image;
import 'package:provider/provider.dart';
import 'package:sada/screen/user/settings_screen.dart';
import 'package:sada/screen/user/task_screen.dart';
import '../../controller/app_data_controller.dart';
import '../../controller/task_controller.dart';
import '../../model/color_model.dart';
import '../user/add_task_screen.dart';
import '../user/all_task_screen.dart';
import 'department_screen.dart';
import '../user/drive_screen.dart';
import 'employees_screen.dart';




class AdminMenuScreen extends StatefulWidget {
  _AdminMenuScreen createState() => _AdminMenuScreen();
}
class _AdminMenuScreen extends State<AdminMenuScreen> {
  @override
  void initState() {
    super.initState();
    final AppDataController appData = Provider.of<AppDataController>(context, listen: false);
    appData.getDataForApp();
  }
  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
  FocusNode focusNode=FocusNode();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final AppDataController appData = Provider.of<AppDataController>(context, listen: true);

    return Scaffold(
      body:   Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
        ColorsModel.ColorTherdLite,
        ColorsModel.ColorSecndLite,
        ],
    )
    ),
    child:Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: size.height*0.05),
            width: size.width,
            height: size.height*0.2,
            child:   Container(
                width: size.width ,
                height: size.height * 0.15,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/image/sada2.png'),
                        alignment: Alignment.center
                    )
                )
            ),
          ),
            Container(
              width: size.width,
              height: size.height*0.75,
                margin: EdgeInsets.symmetric(horizontal: size.width*0.03,),
                padding: EdgeInsets.symmetric(horizontal: size.width*0.03,vertical: size.height*0.05),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        ColorsModel.ColorTherdLite,
                        ColorsModel.ColorSecndLite,
                      ],
                    )
                ),
                child:
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  myButton2("كتابة مهمة",
                      Icons.add_circle_outline, () {
                        final TaskController taskController = Provider.of<TaskController>(context, listen: false);
                        taskController.getAllEmploy();
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => AddTaskScreen()
                            )
                        );
                      }, size),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      myButton("الاقسام",
                          Icons.departure_board_outlined, () {
                            pushToScreen(context,DepartmentScreen());
                          }, size),
                      myButton("الموظفين",
                          Icons.margin_outlined, () {
                            pushToScreen(context,EmployeesScreen());

                          }, size),],),
                  myButton2("المهمات",
                      Icons.task_alt_outlined, () {
                        pushToScreen(context,AllTaskScreen());
                    }, size),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      myButton("رفع التقارير",
                          Icons.paste_rounded, () {
                            pushToScreen(context,DriveScreen());
                          }, size),
                      myButton("الاعدادات",
                          Icons.settings_applications_sharp, () {
                            pushToScreen(context,SettingsScreen());
                          }, size),],),
                ],)
            ),
          ],),
    ));
  }
  Widget myButton(String txt, icon, onTap, size) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: size.width*0.4,
          height: size.height * 0.15,
          margin: EdgeInsets.symmetric(horizontal: size.width*0.01),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                offset: const Offset(1, 1),
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(-1, -1),
              )

            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientIcon(
                icon,
                size.width * 0.1,
                const LinearGradient(
                  begin: Alignment.bottomCenter, colors: [
                  ColorsModel.ColorsMineLite,
                  ColorsModel.ColorsMineLite,
                  ColorsModel.ColorsMineLite],),
              ),
              SizedBox(
                width: size.width * 0.06,
              ),
              Text(
                txt,
                style: TextStyle(
                    fontFamily: "TS-Safaa",
                     color: ColorsModel.ColorsMineLite,
                    fontSize: size.height * 0.03,
                    fontWeight: FontWeight.w600
                ),
              ),


            ],
          )
      ),
    );
  }
  Widget myButton2(String txt, icon, onTap, size) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: size.width*0.9,
          height: size.height * 0.15,
          margin: EdgeInsets.symmetric(horizontal: size.width*0.01),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                ColorsModel.ColorsMineLite,
                ColorsModel.ColorsMineLite,
              ],
            ),            borderRadius: BorderRadius.circular(15
          ),

          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientIcon(
                icon,
                size.width * 0.1,
                const LinearGradient(
                  begin: Alignment.bottomCenter, colors: [
                  Colors.white,
                  Colors.white,

                ],),
              ),
              SizedBox(
                width: size.width * 0.06,
              ),
              Text(
                txt,
                style: TextStyle(
                    fontFamily: "TS-Safaa",
                    color: Colors.white,
                    fontSize: size.height * 0.03,
                    fontWeight: FontWeight.w600
                ),
              ),


            ],
          )
      ),
    );
  }
  Widget myButton3(String txt, icon, onTap, size) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: size.width*0.9,
          height: size.height * 0.15,
          margin: EdgeInsets.symmetric(horizontal: size.width*0.01),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                ColorsModel.ColorsWhite,
                ColorsModel.ColorsWhite,
              ],
            ),            borderRadius: BorderRadius.circular(15
          ),

          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientIcon(
                icon,
                size.width * 0.1,
                 LinearGradient(
                  begin: Alignment.bottomCenter, colors: [
                   ColorsModel.ColorsMineLite,
                   ColorsModel.ColorsMineLite,

                ],),
              ),
              SizedBox(
                width: size.width * 0.06,
              ),
              Text(
                txt,
                style: TextStyle(
                    fontFamily: "TS-Safaa",
                    color: ColorsModel.ColorsMineLite,
                    fontSize: size.height * 0.03,
                    fontWeight: FontWeight.w600
                ),
              ),


            ],
          )
      ),
    );
  }
  fetchData(BuildContext context) async {
    // show the loading dialog
    showDialog(
      // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(
                    color: ColorsModel.ColorsMine,
                  ),
                  // Some text
                ],
              ),
            ),
          );
        });
  }

}
class GradientIcon extends StatelessWidget {
  const GradientIcon(this.icon,
      this.size,
      this.gradient,);

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}

pushToScreen(context,screen){
  return Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => screen
      )
  );
}