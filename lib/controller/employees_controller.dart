import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sada/model/database_model/task.dart';
import 'package:sada/model/database_model/users.dart';
import '../model/database_helper.dart';
import '../model/database_model/department.dart';

class EmployeesController extends ChangeNotifier {
  final DatabaseHelper _databaseHelper=DatabaseHelper();
  List<String> allDepartment=[];
  List departmentList=[];
  int departmentIndex=0;
  int departmentId=0;
  bool isAdmin=false;
  bool isNewUser=false;
  String? departmentName="";
  var userId ;
  TextEditingController username= TextEditingController();
  TextEditingController password= TextEditingController();
  TextEditingController email= TextEditingController();
  TextEditingController phone= TextEditingController();
  TextEditingController description= TextEditingController();
  double currentSliderValue = 20;

  getAllDepartment()async{
    restData();
    List<Department> emp=await _databaseHelper.retrieveDepartmentFromDb();
    if(emp.isNotEmpty){
      for(int i=0;i<emp.length;i++) {
        departmentList.add([emp[i].id,emp[i].department_name]);
        allDepartment.add(emp[i].department_name);
      }
      departmentName=emp[0].department_name;
    }
    notifyListeners();
  }

  setDepartmentName(value){
    for(int i=0;i<departmentList.length;i++){
      if(departmentList[i][1]==value){
        departmentIndex=i;
        departmentName=value;
      }
    }
    notifyListeners();
  }
  Future<void> addEmployees()async{
    Users users=Users(  user_password:password.text,
      user_phone:phone.text,
      user_email:email.text,
      department_id: departmentId,
      user_description: description.text,
      user_name: username.text,
      user_id: userId,
      updated: 1,
      api: 1,
      isAdmin: isAdmin
    );
    await _databaseHelper.insertToTableDB("users", users.toMap());

  }
  setSliderValue(value){
    currentSliderValue=double.parse(value.toString());
    notifyListeners();
  }

  setUpdateData(task){
    email.text = task.completion_rate.toString();
    username.text = task.end_date.toString();
    password.text = task.start_date.toString();
    description.text = task.task_description.toString();
    phone.text = task.task_name.toString();
    currentSliderValue = double.parse(task.completion_rate.toString());
    notifyListeners();
  }
  updateTaskCompleted(id)async{
    await _databaseHelper.updateItemTabletDb("task", id, "task_completed=1,updated=0");
  }
  setIsAdmin(value){
    isAdmin=value;
    notifyListeners();
  }
  restData(){
    allDepartment=[];
    departmentList=[];
    departmentIndex=0;
    username.text="";
    email.text="";
    password.text="";
    phone.text="";
    description.text="";
  }
  Future<List<Task>> getTaskFromDb()async{
    return await _databaseHelper.retrieveTaskFromDb();
  }
  Future<List<Task>> getTaskTypeFromDb(type,create_by)async{
    if(type==1){
      return await _databaseHelper.retrieveTaskCreateByUserFromDb(create_by);
    }else{
      return await _databaseHelper.retrieveTaskCreateByUserFromDb(create_by);
    }
  }
  Future<List<Users>> getEmployeesFromDb()async{
    return await _databaseHelper.retrieveUsersFromDb();
  }
  Future<User> signInWithFirebase() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final UserCredential authResult =
    await _auth.createUserWithEmailAndPassword(password: password.text, email: email.text);
    final User? user = authResult.user;
    final AdditionalUserInfo? additionalUserInfo = authResult.additionalUserInfo;
    if (additionalUserInfo!.isNewUser) {
      isNewUser=true;
      print(user!.uid);
      print('New user logged in.');
    } else {
      isNewUser=false;
      print('Existing user logged in.');
    }
    notifyListeners();
    return user!;
  }
  Future<void> userSetupWithFirebase() async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
     userId = auth.currentUser!.uid.toString();
    users.add({'user_name': username.text, 'user_id': userId,"user_phone":phone.text,"user_email":email.text,"user_password":password.text,
      "isAdmin":isAdmin,"user_description":description.text,"department_id":departmentId});
    notifyListeners();
    return;
  }

}