import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sada/model/database_model/employees.dart';
import 'package:sada/model/database_model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/database_helper.dart';
import '../model/database_model/department.dart';

class TaskController extends ChangeNotifier {
  final DatabaseHelper _databaseHelper=DatabaseHelper();
  List<String> allEmployees=[];
  List employeesList=[];
  int employeesIndex=0;
  String? employeesName;
  TextEditingController name= TextEditingController();
  TextEditingController departmentName= TextEditingController();
  TextEditingController description= TextEditingController();
  TextEditingController startDate= TextEditingController();
  TextEditingController endDate= TextEditingController();
  TextEditingController pitsenteg= TextEditingController();
  double currentSliderValue = 20;

  getAllEmploy()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? displayName=preferences.getString("displayName");
    displayName??"";
    restData();
    List<Employees> emp=await _databaseHelper.retrieveEmployeesFromDb();
    if(emp.isNotEmpty){
      for(int i=0;i<emp.length;i++) {
        employeesList.add([emp[i].employees_name,emp[i].user_id,emp[i].department_id,emp[i].isAdmin]);
        allEmployees.add(emp[i].employees_name);
      }
      employeesName=displayName;
    }else{
      employeesName="خالد";
      allEmployees.add("خالد");
    }
    notifyListeners();
  }

  setEmployName(value){
    for(int i=0;i<employeesList.length;i++){
      if(employeesList[i][1]==value){
        employeesIndex=i;
        employeesName=value;
      }
    }
  notifyListeners();
  }
  addTask(userId)async{
    Task task=Task(completion_rate:pitsenteg.text ,create_by:userId ,start_date:startDate.text ,end_date:endDate.text ,api: 0,
        user_id: employeesList.isNotEmpty?employeesList[employeesIndex][1]:1
        ,updated: 1,department_id:employeesList.isNotEmpty?employeesList[employeesIndex][2]:1,task_completed:0,
        task_description:description.text,date: DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'","em").format(DateTime.now()),
        task_name:name.text);
    await _databaseHelper.insertToTableDB("task", task.toMap());
  }
  setSliderValue(value){
    currentSliderValue=double.parse(value.toString());
    notifyListeners();
  }
  addDepartment()async{
    Department department=Department(department_name: departmentName.text,api: 0,updated: 1);
    await _databaseHelper.insertToTableDB("department", department.toMap());
  }
  setUpdateData(task){
    pitsenteg.text = task.completion_rate.toString();
    endDate.text = task.end_date.toString();
    startDate.text = task.start_date.toString();
    description.text = task.task_description.toString();
    name.text = task.task_name.toString();
    currentSliderValue = double.parse(task.completion_rate.toString());
    notifyListeners();
  }
  updateTaskCompleted(id)async{
    await _databaseHelper.updateItemTabletDb("task", id, "task_completed=1,updated=0");
  }
  updateTask(id)async{
    await _databaseHelper.updateItemTabletDb("task", id, "completion_rate=$currentSliderValue,end_date='${endDate.text}',start_date='${startDate.text}',"
        "task_name='${name.text}',task_description='${description.text}',updated=0");
  }
  restData(){
     allEmployees=[];
     employeesList=[];
     employeesIndex=0;
     employeesName="";
    pitsenteg.text="";
    endDate.text="";
    startDate.text="";
    name.text="";
  }
  Future<List<Task>> getTaskFromDb()async{
    return await _databaseHelper.retrieveTaskFromDb();
  }

  Future<List<Department>> getDepartmentFromDb()async{
    return await _databaseHelper.retrieveDepartmentFromDb();
  }
}