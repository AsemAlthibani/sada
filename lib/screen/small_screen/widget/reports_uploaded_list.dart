import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sada/model/color_model.dart';

class ReportsUploadedListView extends StatelessWidget {
  ReportsUploadedListView(
      {Key? key,
        this.itemList,
        this.callBack,
        this.animationController,
        this.animation})
      : super(key: key);

  final VoidCallback? callBack;
  var itemList;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: InkWell(
              onTap: () async {

              },
              child:
              Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 3),
                  height: size.height * 0.25,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade200,
                          blurRadius: 2,
                          offset: Offset(4, 4)),

                      BoxShadow(color: Colors.grey.shade200,
                          blurRadius: 2,
                          offset: Offset(-4, -4)),

                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),),
                  ),
                  child: Container(
                      height: size.height * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius
                                      .circular(
                                      20),
                                ),
                                height: size.height * 0.09,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width *
                                        0.0015),
                                child: ClipRRect(
                                  borderRadius: BorderRadius
                                      .circular(
                                      17),
                                  child:
                                  Image.asset("assets/image/pdf.png",
                                      fit: BoxFit.contain),
                                )),
                            Padding(padding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.01,),
                                child: Text(
                                  itemList.file_name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: ColorsModel.ColorsMineLite,
                                    fontFamily: "TS-Safaa",
                                    fontSize: size.width * 0.03,
                                    fontWeight: FontWeight
                                        .w500,
                                  ),
                                )),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: size.width*0.02,),
                                child: Text(
                                  DateFormat("hh:mm yyyy-MM-dd",'en').format(DateTime.parse(itemList.date)).toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: ColorsModel.ColorsMineLite,
                                    fontFamily: "TS-Safaa",
                                    fontSize: size.width * 0.03,
                                    fontWeight: FontWeight
                                        .w500,
                                  ),
                                )),
                          ]))),
            ),
          ),
        );
      },
    );
  }
}
class verticalReportsUploadedListView extends StatelessWidget {
  verticalReportsUploadedListView(
      {Key? key,
        this.itemList,
        this.callBack,
        this.animationController,
        this.animation})
      : super(key: key);

  final VoidCallback? callBack;
  var itemList;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: InkWell(
              onTap: () async {

              },
              child:
              Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 3),
                  height: size.height * 0.25,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade200,
                          blurRadius: 2,
                          offset: Offset(4, 4)),

                      BoxShadow(color: Colors.grey.shade200,
                          blurRadius: 2,
                          offset: Offset(-4, -4)),

                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),),
                  ),
                  child: Container(
                      height: size.height * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                height: size.height * 0.06,
                                width: size.height * 0.06,
                                padding: EdgeInsets.symmetric(horizontal: size.width * 0.0015),
                                margin: EdgeInsets.symmetric(horizontal: size.width * 0.005),
                                child: ClipRRect(
                                  borderRadius: BorderRadius
                                      .circular(
                                      17),
                                  child:
                                  Image.asset("assets/image/pdf.png",
                                      fit: BoxFit.contain),
                                )),
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                            Padding(padding: EdgeInsets.symmetric(vertical: size.height*0.0,horizontal: size.width*0.01,),
                                child: Text(
                                  itemList.file_name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: ColorsModel.ColorsMineLite,
                                    fontFamily: "TS-Safaa",
                                    fontSize: size.width * 0.035,
                                    fontWeight: FontWeight
                                        .w500,
                                  ),
                                )),
                            SizedBox(height: size.height*0.01,),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: size.width*0.02,),
                                child: Text(
                                  DateFormat("hh:mm yyyy-MM-dd",'en').format(DateTime.parse(itemList.date)).toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: ColorsModel.ColorsMineLite,
                                    fontFamily: "TS-Safaa",
                                    fontSize: size.width * 0.035,
                                    fontWeight: FontWeight
                                        .w500,
                                  ),
                                )),
                           ],)
                          ]))),
            ),
          ),
        );
      },
    );
  }
}
