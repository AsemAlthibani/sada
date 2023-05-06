import 'package:flutter/cupertino.dart';
import 'package:sada/model/database_helper.dart';
import 'package:sada/model/database_model/task.dart';
import 'package:sada/screen/small_screen/widget/most_accomplished_tasks.dart';

import '../model/database_model/employees.dart';
import '../screen/small_screen/widget/task_report_charts.dart';

class TaskReportController extends ChangeNotifier {
  final DatabaseHelper _databaseHelper=DatabaseHelper();
  double? highestTasks;
  final List employeesTaskCompleted = [];
  final List employeesTaskNotCompleted = [];
  final List mostAccomplishedTasks = [];


  Future<void> setReportData(bool isAll,startDate,endDate)async{
    employeesTaskCompleted.length=0;
    employeesTaskCompleted.length=0;
    mostAccomplishedTasks.length=0;
    List<Employees> employees = await _databaseHelper.retrieveEmployeesFromDb('SELECT * FROM employees where isAdmin=0');
    List taskEmployees = isAll? await _databaseHelper.retrieveTaskReportFromDb("SELECT count(*) as completed_tasks,"
        "emp_name,emp_id FROM task  "
        "GROUP BY emp_id ORDER BY completed_tasks DESC LIMIT 3;"):await _databaseHelper.retrieveTaskReportFromDb("SELECT count(*) as completed_tasks,"
    "emp_name,emp_id FROM task WHERE date BETWEEN  '$startDate' AND '$endDate'  "
    "GROUP BY emp_id ORDER BY completed_tasks DESC LIMIT 3;");
    for (var item in employees) {
      List taskEmployees =  isAll?await _databaseHelper.retrieveTaskReportFromDb('SELECT count(*) as completed_tasks FROM task  WHERE emp_id = "${item.user_id}" And task_completed=1 '):
      await _databaseHelper.retrieveTaskReportFromDb('SELECT count(*) as completed_tasks  FROM task  WHERE date BETWEEN  "$startDate" AND "$endDate" AND  emp_id = "${item.user_id}" And task_completed=1 ');
      List taskEmployeesIncomplete =  isAll?await _databaseHelper.
      retrieveTaskReportFromDb('SELECT count(*) as  incomplete_tasks FROM task  WHERE emp_id = "${item.user_id}" And task_completed=0 '):
      await _databaseHelper.retrieveTaskReportFromDb('SELECT count(*) as incomplete_tasks  FROM task  WHERE date BETWEEN  "$startDate" AND "$endDate" AND  emp_id = "${item.user_id}" And task_completed=0 ');

      print(taskEmployees);
      print(taskEmployees.last["completed_tasks"]);
      employeesTaskCompleted.add([
        item.employees_name,
        double.parse(taskEmployees.last["completed_tasks"].toStringAsFixed(2))
      ]);
      employeesTaskNotCompleted.add([
        item.employees_name,
        double.parse(taskEmployeesIncomplete.last["incomplete_tasks"].toStringAsFixed(2))
      ]);
    }
    for (int i = 0; i < taskEmployees.length; i++) {
      List taskEmployeesC =  isAll?await _databaseHelper.retrieveTaskReportFromDb('SELECT count(*) as completed_tasks FROM task  WHERE emp_id = "${taskEmployees[i]["emp_id"]}" And task_completed=1 ')
      :await _databaseHelper.retrieveTaskReportFromDb('SELECT count(*) as completed_tasks FROM task  WHERE date BETWEEN  "$startDate" AND "$endDate" AND emp_id = "${taskEmployees[i]["emp_id"]}" And task_completed=1 ');
      List taskEmployeesNC =  isAll?await _databaseHelper.retrieveTaskReportFromDb('SELECT count(*) as incomplete_tasks FROM task  WHERE emp_id = "${taskEmployees[i]["emp_id"]}" And task_completed=0 ')
      :await _databaseHelper.retrieveTaskReportFromDb('SELECT count(*) as incomplete_tasks FROM task  WHERE date BETWEEN  "$startDate" AND "$endDate" AND emp_id = "${taskEmployees[i]["emp_id"]}" And task_completed=0 ');
      mostAccomplishedTasks.add(RecentUser(name: taskEmployees[i]["emp_name"].toString(),all_task: taskEmployees[i]["completed_tasks"].toString(),completed_tasks:taskEmployeesC.last["completed_tasks"].toString(),incomplete_tasks: taskEmployeesNC.last["incomplete_tasks"].toString()));
    }
    if(taskEmployees.isNotEmpty){
      highestTasks=double.parse(taskEmployees.last["completed_tasks"].toStringAsFixed(2));
    }
    await setEmployeesTaskCompleted();
    notifyListeners();
  }
  Future<void> setEmployeesTaskCompleted()async{
    femaleData.length=0;
    maleData.length=0;
    for(int i=0;i<employeesTaskCompleted.length;i++){
      femaleData.add(UsersAgeData(employeesTaskCompleted[i][0],double.parse(employeesTaskCompleted[i][1].toString()),"المهام المكتملة"));
    }
    for(int i=0;i<employeesTaskNotCompleted.length;i++){
      maleData.add(UsersAgeData(employeesTaskNotCompleted[i][0],double.parse(employeesTaskNotCompleted[i][1].toString()),"المهام الغير المكتملة"));
    }
    notifyListeners();
  }
}