import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sada/model/color_model.dart';

import '../../../model/database_model/department.dart';

class DepartmentListView extends StatelessWidget {
  DepartmentListView(
      {Key? key,
        this.itemList,
        this.callBack,
        this.callBack2,
        this.animationController,
        this.animation})
      : super(key: key);

  final VoidCallback? callBack;
  final VoidCallback? callBack2;
  Department? itemList;
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
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: InkWell(
              onTap: callBack,
              onLongPress: callBack2,
              child:
              Container(
                  padding:  EdgeInsets.symmetric(
                      horizontal: size.width*0.02),
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
                      height: size.height * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            Padding(padding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.02,),
                                child: Text(
                                  itemList!.department_name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: ColorsModel.ColorsMineLite,
                                    fontFamily: "TS-Safaa",
                                    fontSize: size.width * 0.04,
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
