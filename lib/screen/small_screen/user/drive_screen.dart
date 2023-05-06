import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sada/model/color_model.dart';
import '../../../controller/app_data_controller.dart';
import '../../../controller/firebase/drive_upload_controller.dart';
import '../widget/reports_uploaded_list.dart';
import '../widget/update_task_widget.dart';




class DriveScreen extends StatefulWidget {
  @override
  DriveScreenState createState() {
    return  DriveScreenState();
  }
}

class DriveScreenState extends State<DriveScreen> with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    // TODO: implement initState
    animationController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    final DriveUploadController getDataFirestore = Provider.of<DriveUploadController>(context, listen: false);
    final AppDataController appDataListen = Provider.of<AppDataController>(context, listen: false);
    getDataFirestore.getFileUploaded(appDataListen.userId);
    getDataFirestore.login();
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
    final DriveUploadController driveUploadController = Provider.of<DriveUploadController>(context, listen: true);
    final DriveUploadController driveUpload = Provider.of<DriveUploadController>(context, listen: false);
    final AppDataController appData = Provider.of<AppDataController>(context, listen: false);
    final AppDataController appDataListen = Provider.of<AppDataController>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: driveUploadController.scaffold,
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
          "رفع التقاير",
          style: TextStyle(
              fontFamily: "TS-Safaa",
              color: ColorsModel.ColorsMineLite,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.w500
          ),
        ),
        centerTitle: true,

      ),
      floatingActionButton:FloatingActionButton(
        onPressed: (){
          driveUpload.getFileFromDevice(context,appData.userId,size);
        },
        backgroundColor: ColorsModel.ColorsMineLite,
        tooltip: 'Upload File',
        child: Icon(Icons.add),
      ),
      body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                appDataListen.isAdmin!?Container(
                    width: double.infinity,
                    height: size.height*0.07,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: size.width*0.01,vertical: size.height*0.006),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child:Row(children:[
                          rowButton(size, 'التقارير التي رفعتها', Icons.all_inclusive_outlined, 1, ()async{
                            setStatusColor(1);
                            driveUpload.setType(1);
                            await driveUpload.getFileUploaded(appDataListen.userId);
                          }),
                          rowButton(size, 'التقارير التي رفعتها الموظفين', Icons.all_inclusive_outlined, 2, ()async{
                            setStatusColor(2);
                            driveUpload.setType(2);
                            await driveUpload.getFileUploaded(appDataListen.userId);
                          }),
                        ]))):Container(),

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
                        appDataListen.multipleReports! ? Icons.dashboard : Icons.view_agenda,
                        size: size.width*0.06,
                      ),
                      onTap: () {
                        appData.setMultipleStateReports();
                      },
                    ),
                  ],
                ),
                Expanded(
                  child:driveUploadController.listReportsUploaded.isNotEmpty?GridView(
                    padding: const EdgeInsets.only(
                        top: 0, left: 12, right: 12),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: appDataListen.multipleReports! ? 2 : 1,
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                      childAspectRatio: appDataListen.multipleReports! ?1.5:5,
                    ),
                    children: List<Widget>.generate(
                      driveUploadController.listReportsUploaded.length,
                          (int index) {
                        final int count = driveUploadController.listReportsUploaded.length;
                        final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animationController!,
                            curve: Interval((1 / count) * index, 1.0,
                                curve: Curves.fastOutSlowIn),
                          ),
                        );
                        animationController?.forward();
                        return appDataListen.multipleReports!?ReportsUploadedListView(
                          animation: animation,
                          animationController: animationController,
                          itemList: driveUploadController.listReportsUploaded[index],
                          callBack: () async{
                            downloadReportsUploaded(context,size,driveUploadController.listReportsUploaded[index]);
                            },
                        ):verticalReportsUploadedListView(
                          animation: animation,
                          animationController: animationController,
                          itemList: driveUploadController.listReportsUploaded[index],
                          callBack: () {
                            downloadReportsUploaded(context,size,driveUploadController.listReportsUploaded[index]);
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
              ]),
    );
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
