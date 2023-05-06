import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sada/model/database_model/employees.dart';
import 'package:sada/model/database_model/note.dart';
import 'package:sada/model/database_model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/database_helper.dart';
import '../model/database_model/deleted_item.dart';
import '../model/database_model/department.dart';
import '../model/database_model/reports_uploaded.dart';

class TaskController extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<String> allEmployees = [];
  List employeesList = [];
  int employeesIndex = 0;
  int taskIndex = 0;
  String? employeesName;
  int type = 1;
  Task? task;
  Department? department;
  TextEditingController name = TextEditingController();
  TextEditingController not = TextEditingController();
  TextEditingController fileNameReportsUploaded = TextEditingController();
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
  TextEditingController noteDetails = TextEditingController();
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
    List<Employees> emp = await _databaseHelper.retrieveEmployeesFromDb('SELECT * FROM employees');
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
        create_at: DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", "en").format(DateTime.now()),
        api: 0,
        updated: 1);
   await _databaseHelper.insertToTableDB("department", department.toMap());
  }
  updateDepartment(id) async {
        await _databaseHelper.updateItemTabletDb(
            "department", id, "updated=0,department_name='${departmentName.text}'");
      }
  setDepartment(Department department) async {
    this.department=department;
    departmentName.text=department.department_name;
  notifyListeners();
  }
  deleteDepartment(Department department,delete_by,index) async {
    DeletedItem deletedItem=DeletedItem(
      delete_at: DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", "en").format(DateTime.now()),
      delete_by: delete_by,
      item_type: 4,
      online_id:department.online_id,
      api: 1,);
    await _databaseHelper.insertToTableDB("deleted_item", deletedItem.toMap());
    await _databaseHelper.deleteItemsInTableDb("department", department.id);
    taskList.removeAt(index);
    notifyListeners();
  }

  setUpdateData(task,vlue) {
    this.task=task;
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
  updateTaskNewAdd(Task task,index) async {
    if(task.new_add==0){
      await _databaseHelper.updateItemTabletDb("task", task.id, "new_add=1");
      taskList[index].new_add=1;
      _taskList[index].new_add=1;
    notifyListeners();
    }
  }
akjdjs(id)async{
    print("object");
  await _databaseHelper.updateItemTabletDb("task", id, "updated=0 ");
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
  deleteTask(Task task,delete_by,index) async {
    DeletedItem deletedItem=DeletedItem(
        delete_at: DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", "en").format(DateTime.now()),
        delete_by: delete_by,
        item_type: 1,
        online_id:task.online_id,
        api: 1,);
    await _databaseHelper.insertToTableDB("deleted_item", deletedItem.toMap());
    await _databaseHelper.deleteItemsInTableDb("task", task.id);
    taskList.removeAt(index);
    notifyListeners();
  }


  restData() {
    allEmployees = [];
    employeesList = [];
    type = 1;
    employeesIndex = 0;
    not.text="";
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

  Future<void> getDepartmentFromDb() async {
    departmentList= await _databaseHelper.retrieveDepartmentFromDb('SELECT * FROM department');
    _departmentList=departmentList;
    notifyListeners();
  }

  List<Task> taskList = [];
  List<Task> _taskList = [];
  List<AdminNote> noteList = [];
  List<AdminNote> _noteList = [];
  List<Department> departmentList =[];
  List<Department> _departmentList =[];

  getTaskToList(userId) async {
    print("$type type");
    taskList = await getTaskTypeFromDb(type, userId);
    _taskList=taskList;
    notifyListeners();
  }
  getAdminNoteToList(userId) async {
    print("$type type");
    noteList = await getNoteTypeFromDb(type, userId);
    _noteList=noteList;
    notifyListeners();
  }
  restType() async {
   type=1;
  }
  updateAdminNoteNewAdd(Task task,index) async {
    if(task.new_add==0){
      await _databaseHelper.updateItemTabletDb("task", task.id, "new_add=1");
      noteList[index].new_add=1;
      _noteList[index].new_add=1;
      notifyListeners();
    }
  }

  getTaskAdminToList(userId) async {
    taskList = await getTaskTypeForAdminFromDb(type, userId);
    _taskList=taskList;
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

  Future<List<AdminNote>> getNoteTypeFromDb(type, create_by) async {
    if (type == 1) {
      return await _databaseHelper.retrieveAdminNoteFromDb(
          'SELECT * FROM admin_note where note_type=1 and emp_id="$create_by"');
    } else {
      return await _databaseHelper.retrieveAdminNoteFromDb(
          'SELECT * FROM admin_note where note_type=2 and emp_id="$create_by"');
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

  void taskFilter(String enteredKeyword) {
    List<Task> results = [];
    if (enteredKeyword.isEmpty) {
      results = _taskList;
    } else {
      results = _taskList
          .where((user) =>
          user.task_name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    taskList=results;
    notifyListeners();
  }

  void departmentFilter(String enteredKeyword) {
    List<Department> results = [];
    if (enteredKeyword.isEmpty) {
      results = _departmentList;
    } else {
      results = _departmentList
          .where((user) =>
          user.department_name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    departmentList=results;
    notifyListeners();
  }

  setType(value) {
    type = value;
    notifyListeners();
  }

  addNoteFileUploaded(userId,displayName,isAdmin,note_type) async {
    if(not.text!=""){
    var date=DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", "en").format(DateTime.now());
    AdminNote adminNote=AdminNote(
        note_description: not.text,
        emp_id: task!.create_by,
        updated:1,
        reports_id:task!.online_id ,
        isAdmin: isAdmin?1:0,
        api: 0,
        create_by: userId,
        create_by_name: displayName,
        emp_name: task!.create_by_name,
        date: date,
        note_type: note_type,
        new_add: 0);
    int id=await _databaseHelper.insertToTableDB("admin_note", adminNote.toMap());
    print("${task!.id} task!.id");
    }
    await _databaseHelper.updateItemTabletDb("task", task!.id, "updated=0,enable_admin=1 ");
  }

  setNoteTask(noteList,type)async{
    if(type==1){
    List taskListForNote=await _databaseHelper.retrieveTaskFromDb('SELECT * FROM task where online_id="${noteList.reports_id}" ');
    not.text=noteList.note_description;
    if(taskListForNote.isNotEmpty){
      setUpdateData(taskListForNote.last,0);
    }
    }else{
      List<ReportsUploaded> oldData = await _databaseHelper.retrieveReportsUploadedFromDb('SELECT * FROM reports_uploaded where online_id="${noteList.reports_id}"');
      not.text=noteList.note_description;
      if(oldData.isNotEmpty){
        fileNameReportsUploaded.text=oldData.last.file_name;
      }
    }
  notifyListeners();
  }
}