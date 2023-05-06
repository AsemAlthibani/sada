import 'package:sada/controller/task_report_controller.dart';
import 'package:sada/model/color_model.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MostAccomplishedTasks extends StatelessWidget {
  const MostAccomplishedTasks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TaskReportController taskReportController=Provider.of<TaskReportController>(context, listen: true);
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: ColorsModel.ColorsWhite,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الاكثر انجازا",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              horizontalMargin: 0,
              columnSpacing: 13,
              columns: [
                DataColumn(
                  label: Text("الموظف "),
                ),
                DataColumn(
                  label: Text("جميع المهام"),
                ),
                DataColumn(
                  label: Text("المهام المكتملة"),
                ),
                DataColumn(
                  label: Text("المهام الغير مكتملة"),
                ),
              ],
              rows: List.generate(
                taskReportController.mostAccomplishedTasks.length,
                (index) => recentUserDataRow(taskReportController.mostAccomplishedTasks[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentUserDataRow(RecentUser userInfo) {
  return DataRow(
    cells: [
      DataCell(Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: ColorsModel.ColorsMine,
            border: Border.all(color: ColorsModel.ColorsMine),
            borderRadius: BorderRadius.all(Radius.circular(5.0) //
                ),
          ),
          child: Text(userInfo.name!,style: TextStyle(color: Colors.white),))),
      DataCell(Text(userInfo.all_task!,textAlign: TextAlign.center,)),
      DataCell(Text(userInfo.completed_tasks??"")),
      DataCell(Text(userInfo.incomplete_tasks??"")),
    ],
  );
}
class RecentUser {
  final String? name, all_task,completed_tasks, incomplete_tasks;

  RecentUser(
      {this.all_task, this.name,this.completed_tasks, this.incomplete_tasks});
}

