import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sada/screen/user/task_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/app_data_controller.dart';
import '../../model/color_model.dart';

class AllTaskScreen extends StatefulWidget {
  @override
  _AllTaskScreen createState() => _AllTaskScreen();
}

class _AllTaskScreen extends State<AllTaskScreen> with SingleTickerProviderStateMixin {

  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }



  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final AppDataController appData = Provider.of<AppDataController>(context, listen: true);
    bool isorientation= MediaQuery.of(context).orientation == Orientation.landscape;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter, colors: [
                ColorsModel.ColorsMineLite, ColorsModel.ColorsMineLite],
              ),

            ),
          ),
          backgroundColor: ColorsModel.ColorsMineLite,
          title: Text(
            "المهام",
            style: TextStyle(
                fontFamily: "TS-Safaa",
                color: Colors.white,
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.w500
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white
            ),),
          actions: [
          ]
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color:Colors.black, width: 0.2 ),
                  top:  BorderSide(color:Colors.black,width: 0.2 ),

                ),
              ),
              child: Column(
                children: [
                  TabBar(
                    unselectedLabelColor: Colors.black,
                    labelColor: Colors.black,
                    indicatorColor: Colors.black,
                    indicatorWeight: 2,
                    indicator: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color:ColorsModel.ColorsMineLite,width: 2  )
                      ),
                    ),
                    controller: tabController,
                    tabs: const [
                      Tab(
                        text: 'المهام اللتي انشئتها',
                      ),
                      Tab(
                        text: 'المهمام الموكلة اليك',
                      ),
                    ],

                  ),

                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  TaskScreen(type: 1,userId: appData.userId,),
                  TaskScreen(type: 2,userId:appData.userId),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
class Tab1 extends StatelessWidget {
  const Tab1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Tab 1')),
    );
  }
}
