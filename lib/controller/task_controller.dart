import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sada/model/database_model/employees.dart';
import 'package:sada/model/database_model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/database_helper.dart';
import '../model/database_model/department.dart';

class TaskController extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<String> allEmployees = [];
  List employeesList = [];
  int employeesIndex = 0;
  int taskIndex = 0;
  String? employeesName;
  int type = 1;
  TextEditingController name = TextEditingController();
  TextEditingController not = TextEditingController();
  TextEditingController departmentName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController empName = TextEditingController();
  TextEditingController createByName = TextEditingController();
  TextEditingController nameDetails = TextEditingController();
  TextEditingController departmentNameDetails = TextEditingController();
  TextEditingController descriptionDetails = TextEditingController();
  TextEditingController startDateDetails = TextEditingController();
  TextEditingController endDateDetails = TextEditingController();
  TextEditingController empNameDetails = TextEditingController();
  TextEditingController createByNameDetails = TextEditingController();
  TextEditingController pitsentegDetails = TextEditingController();
  TextEditingController pitsenteg = TextEditingController();
  double currentSliderValue = 20;
  double currentSliderValueDetails = 20;

  getAllEmploy() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? displayName = preferences.getString("displayName");
    bool? isAdmin = preferences.getBool("isAdmin");
    displayName ??= "";
    isAdmin ??= false;
    restData();
    List<Employees> emp = await _databaseHelper.retrieveEmployeesFromDb();
    if (emp.isNotEmpty) {
      for (int i = 0; i < emp.length; i++) {
        employeesList.add([
          emp[i].employees_name,
          emp[i].user_id,
          emp[i].department_id,
          emp[i].isAdmin
        ]);
        allEmployees.add(emp[i].employees_name);
      }
      if (!isAdmin) {
        setEmployName(displayName);
      } else {
        employeesName = emp[0].employees_name.toString();
      }
      print(allEmployees);
    } else {
      employeesName = "خالد";
      allEmployees.add("خالد");
    }
    notifyListeners();
  }

  setEmployName(value) {
    for (int i = 0; i < employeesList.length; i++) {
      if (employeesList[i][0].toString() == value.toString()) {
        employeesIndex = i;
        employeesName = value;
        print(employeesList[i][1]);
      }
    }
    notifyListeners();
  }

  addTask(userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? displayName = preferences.getString("displayName");
    bool? isAdmin = preferences.getBool("isAdmin");
    isAdmin ??= false;
    var create_by = userId;
    var user_id = employeesList.isNotEmpty
        ? employeesList[employeesIndex][1]
        : userId;
    Task task = Task(completion_rate: pitsenteg.text,
        create_by: create_by,
        start_date: startDate.text,
        end_date: endDate.text,
        api: 0,
        emp_id: user_id,
        emp_name: employeesList.isNotEmpty
            ? employeesList[employeesIndex][0]
            : "",
        create_by_name: displayName ?? "",
        updated: 1,
        department_id: employeesList.isNotEmpty
            ? employeesList[employeesIndex][2]
            : 1,
        task_completed: 0,
        task_description: description.text,
        date: DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", "en").format(
            DateTime.now()),
        task_name: name.text,
        enable_admin: isAdmin ? 1 : 0,
        for_admin: isAdmin ? 0 : user_id == create_by ? 0 : 1);
    await _databaseHelper.insertToTableDB("task", task.toMap());
  }

  setSliderValue(value) {
    currentSliderValue = double.parse(value.toString());
    notifyListeners();
  }

  addDepartment(create_by) async {
    Department department = Department(department_name: departmentName.text,
        create_by: create_by,
        create_at: DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", "en").format(
            DateTime.now()),
        api: 0,
        updated: 1);
   await _databaseHelper.insertToTableDB("department", department.toMap());
  }

  setUpdateData(task,vlue) {
    pitsenteg.text = task.completion_rate.toString();
    endDate.text = task.end_date.toString();
    startDate.text = task.start_date.toString();
    description.text = task.task_description.toString();
    name.text = task.task_name.toString();
    createByName.text = task.create_by_name.toString();
    empName.text = task.emp_name.toString();
    currentSliderValue = double.parse(task.completion_rate.toString());
    pitsentegDetails.text = task.completion_rate.toString();
    endDateDetails.text = task.end_date.toString();
    startDateDetails.text = task.start_date.toString();
    descriptionDetails.text = task.task_description.toString();
    nameDetails.text = task.task_name.toString();
    createByNameDetails.text = task.create_by_name.toString();
    empNameDetails.text = task.emp_name.toString();
    currentSliderValueDetails = double.parse(task.completion_rate.toString());
    taskIndex=vlue;
    notifyListeners();
  }

  updateTaskCompleted(task) async {
    if (task.api.toString() == "0" && task.online_id == null) {
      await _databaseHelper.updateItemTabletDb(
          "task", task.id, "task_completed=1");
    } else {
      await _databaseHelper.updateItemTabletDb(
          "task", task.id, "task_completed=1,updated=0");
    }
  }

  updateTask() async {
    if (taskList[taskIndex].api.toString() == "0" && taskList[taskIndex].online_id == null) {
      await _databaseHelper.updateItemTabletDb("task", taskList[taskIndex].id,
          "completion_rate=$currentSliderValue,end_date='${endDate
              .text}',start_date='${startDate.text}',"
              "task_name='${name.text}',task_description='${description
              .text}'");
    } else {
      await _databaseHelper.updateItemTabletDb("task", taskList[taskIndex].id,
          "completion_rate=$currentSliderValue,end_date='${endDate
              .text}',start_date='${startDate.text}',"
              "task_name='${name.text}',task_description='${description
              .text}',updated=0");
    }
  }

  deleteTask(id) async {
    await _databaseHelper.deleteItemsInTableDb("task", id);
//    await _databaseHelper.deleteSequenceItemsInTableDb("task",id);
  }

  restData() {
    allEmployees = [];
    employeesList = [];
    type = 1;
    employeesIndex = 0;
    taskIndex = 0;
    employeesName = "";
    pitsenteg.text = "";
    endDate.text = "";
    startDate.text = "";
    name.text = "";
    description.text = "";
    pitsentegDetails.text = "";
    endDateDetails.text = "";
    startDateDetails.text = "";
    nameDetails.text = "";
    descriptionDetails.text = "";
  }

  Future<List<Department>> getDepartmentFromDb() async {
    return await _databaseHelper.retrieveDepartmentFromDb();
  }

  List<Task> taskList = [];

  getTaskToList(userId) async {
    print("$type type");
    taskList = await getTaskTypeFromDb(type, userId);
    notifyListeners();
  }
  getTaskAdminToList(userId) async {
    print("$type type");
    taskList = await getTaskTypeForAdminFromDb(type, userId);
    notifyListeners();
  }

  Future<List<Task>> getTaskTypeFromDb(type, create_by) async {
    if (type == 1) {
      return await _databaseHelper.retrieveTaskFromDb(
          'SELECT * FROM task where create_by="$create_by" AND  emp_id="$create_by"');
    } else if (type == 2) {
      return await _databaseHelper.retrieveTaskFromDb(
          'SELECT * FROM task where create_by !="$create_by" AND  emp_id="$create_by"');
    } else {
      return await _databaseHelper.retrieveTaskFromDb(
          'SELECT * FROM task where create_by="$create_by" AND  emp_id !="$create_by"');
    }
  }

  Future<List<Task>> getTaskTypeForAdminFromDb(type, create_by) async {
    if (type == 1) {
      return await _databaseHelper.retrieveTaskFromDb(
          'SELECT * FROM task where enable_admin=0 AND for_admin=1 ');
    } else {
      return await _databaseHelper.retrieveTaskFromDb(
          'SELECT * FROM task where enable_admin=1 AND for_admin=1');
    }
  }

  setType(value) {
    type = value;
    notifyListeners();
  }
}