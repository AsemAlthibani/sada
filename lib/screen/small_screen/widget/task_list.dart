import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sada/model/color_model.dart';
import 'package:sada/model/database_model/task.dart';


class TaskListView extends StatelessWidget {
  TaskListView(
      {Key? key,
        this.itemList,
        this.callBack,
        this.callBack2,
        this.animationController,
        this.animation})
      : super(key: key);

  final VoidCallback? callBack;
  final VoidCallback? callBack2;
  Task? itemList;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color myColors=Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 20 * (1.0 - animation!.value), 0.0),
            child: InkWell(
              onTap: callBack,
              child:
              SizedBox(
                  height: size.height*0.2,
                  child: Container(
                        margin: EdgeInsets.all(size.width * 0.01,),
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          //color: Colors.white,//(0xff757575),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            )
                          ],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0),
                            bottomLeft: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: size.width * 0.01,
                          horizontal: size.width * 0.02,
                        ),
                        width: double.infinity,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius
                                                .all(
                                                Radius.circular(
                                                    50)),
                                          ),
                                          width: size.width * 0.1,
                                          height: size.width * 0.1,
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              width: size.width * 0.1,
                                              height: size.height * 0.02,
                                              child: ClipRRect(
                                                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                                                  child: Container(
                                                      alignment: Alignment.center,
                                                      color: myColors,
                                                      child: Text(
                                                          itemList!.id.toString(),
                                                          textAlign: TextAlign.center,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            fontFamily: "Almarai",
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: size.width * 0.04,
                                                          ))
                                                  )
                                              )
                                          )
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.01,),
                                        width: size.width * 0.3,
                                        child: Text(
                                            itemList!.task_name,
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: ColorsModel.ColorsMineLite,
                                              fontFamily: "TS-Safaa",
                                              fontSize: size.width * 0.035,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),),
                                    ],
                                  ),
                              Container(
                                  padding: EdgeInsets.symmetric(vertical:0,horizontal: size.width*0.01,),
                                  width: double.infinity,
                                  child: Text(
                                    "المنشئ: ${itemList!.create_by_name}",
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
                              Container(
                                  padding: EdgeInsets.symmetric(vertical:0,horizontal: size.width*0.01,),
                                  width: double.infinity,

                                  child:Text(
                                    "المكلف: ${itemList!.emp_name}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: ColorsModel.ColorsMineLite,
                                      fontFamily: "TS-Safaa",
                                      fontSize: size.width * 0.03,
                                      fontWeight: FontWeight
                                          .w500,
                                    ),
                                  )
                              ),
                             Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Container(
                                         alignment: Alignment.center,
                                         width: size.width * 0.27,
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(5),
                                           color: ColorsModel.ColorTherdLite,
                                         ),
                                         child:
                                         Text(
                                         "نسبة الانجاز: ${itemList!.completion_rate}%",
                                         overflow: TextOverflow.ellipsis,
                                         maxLines: 1,
                                         textAlign: TextAlign.end,
                                         style: TextStyle(
                                           color: ColorsModel.ColorsMineLite,
                                           fontFamily: "TS-Safaa",
                                           fontSize: size.width * 0.03,
                                           fontWeight: FontWeight.w500,
                                         ),
                                       ),),
                                       Text(
                                           "تاريخ الانتهاء : ${itemList!.end_date}",
                                           overflow: TextOverflow.ellipsis,
                                           maxLines: 1,
                                           style: TextStyle(
                                             color: ColorsModel.ColorsMineLite,
                                             fontFamily: "TS-Safaa",
                                             fontSize: size.width * 0.028,
                                             fontWeight: FontWeight.w500,
                                           ),
                                         ),

                                     ],
                                   ),
                                   InkWell(
                                onTap: callBack2,
                                child:Container(
                                  width: size.width * 0.1,
                                  height: size.width * 0.1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: itemList!.task_completed==1?ColorsModel.ColorsMineLite:
                                      ColorsModel.ColorsWhite,
                                      border: Border.all(color: ColorsModel.ColorsMineLite,width: itemList!.task_completed==1?0:1
                                      )
                                  ),
                                  child: Icon(
                                    Icons.done_outlined,
                                    color: itemList!.task_completed==1?ColorsModel.ColorsWhite:ColorsModel.ColorsMineLite,
                                    size:  size.height*0.04,
                                  ),
                                ) ,),])
                            ]

                        )
                    ),)),
            ),
        );
      },
    );
  }
}
class verticalTaskListView extends StatelessWidget {
  verticalTaskListView(
      {Key? key,
        this.itemList,
        this.callBack,
        this.callBack2,
        this.animationController,
        this.animation})
      : super(key: key);

  final VoidCallback? callBack;
  final VoidCallback? callBack2;
  var itemList;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color myColors=Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 20 * (1.0 - animation!.value), 0.0),
            child: InkWell(
                onTap: callBack,
                child:
                SizedBox(
                  height: size.height*0.2,
                  child: Container(
                      margin: EdgeInsets.all(size.width * 0.01,),
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        //color: Colors.white,//(0xff757575),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          )
                        ],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                          bottomLeft: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: size.width * 0.01,
                        horizontal: size.width * 0.02,
                      ),
                      width: double.infinity,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius
                                          .all(
                                          Radius.circular(
                                              50)),
                                    ),
                                    width: size.width * 0.1,
                                    height: size.width * 0.1,
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        width: size.width * 0.1,
                                        height: size.height * 0.02,
                                        child: ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(100)),
                                            child: Container(
                                                alignment: Alignment.center,
                                                color: myColors,
                                                child: Text(
                                                    itemList!.id.toString(),
                                                    textAlign: TextAlign.center,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: "Almarai",
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: size.width * 0.04,
                                                    ))
                                            )
                                        )
                                    )
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.01,),
                                  width: size.width * 0.65,
                                  child: Text(
                                    itemList!.task_name,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: ColorsModel.ColorsMineLite,
                                      fontFamily: "TS-Safaa",
                                      fontSize: size.width * 0.035,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),),
                                InkWell(
                                  onTap: callBack2,
                                  child:Container(
                                    width: size.width * 0.1,
                                    height: size.width * 0.1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: itemList!.task_completed==1?ColorsModel.ColorsMineLite:
                                        ColorsModel.ColorsWhite,
                                        border: Border.all(color: ColorsModel.ColorsMineLite,width: itemList!.task_completed==1?0:1
                                        )
                                    ),
                                    child: Icon(
                                      Icons.done_outlined,
                                      color: itemList!.task_completed==1?ColorsModel.ColorsWhite:ColorsModel.ColorsMineLite,
                                      size:  size.height*0.04,
                                    ),
                                  ) ,),
                              ],
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(vertical:0,horizontal: size.width*0.01,),
                                width: size.width*0.87,
                                child: Text(
                                  "المنشئ: ${itemList!.create_by_name}",
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
                           Row(
                             children: [
                               Container(
                                   padding: EdgeInsets.symmetric(vertical:0,horizontal: size.width*0.01,),
                                   width: size.width*0.6,
                                   child:Text(
                                     "المكلف: ${itemList!.emp_name}",
                                     overflow: TextOverflow.ellipsis,
                                     maxLines: 1,
                                     style: TextStyle(
                                       color: ColorsModel.ColorsMineLite,
                                       fontFamily: "TS-Safaa",
                                       fontSize: size.width * 0.03,
                                       fontWeight: FontWeight
                                           .w500,
                                     ),
                                   )
                               ),
                               Container(
                                 alignment: Alignment.center,
                                 width: size.width * 0.27,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(5),
                                   color: ColorsModel.ColorTherdLite,
                                 ),
                                 child:
                                 Text(
                                   "نسبة الانجاز: ${itemList!.completion_rate}%",
                                   overflow: TextOverflow.ellipsis,
                                   maxLines: 1,
                                   textAlign: TextAlign.end,
                                   style: TextStyle(
                                     color: ColorsModel.ColorsMineLite,
                                     fontFamily: "TS-Safaa",
                                     fontSize: size.width * 0.03,
                                     fontWeight: FontWeight.w500,
                                   ),
                                 ),),
                             ],
                           )

                          ]

                      ),
                          ])
                  ),)),
          ),
        );
      },
    );
  }
}
