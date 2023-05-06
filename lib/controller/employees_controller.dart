import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sada/model/database_model/task.dart';
import 'package:sada/model/database_model/users.dart';
import '../model/database_helper.dart';
import '../model/database_model/deleted_item.dart';
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
  Users? users;
  TextEditingController username= TextEditingController();
  TextEditingController password= TextEditingController();
  TextEditingController email= TextEditingController();
  TextEditingController phone= TextEditingController();
  TextEditingController description= TextEditingController();

  getAllDepartment()async{
    restData();
    List<Department> emp=await _databaseHelper.retrieveDepartmentFromDb('SELECT * FROM department');
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
  Future<void> addEmployees(create_by)async{
    Users users=Users(  user_password:password.text,
      user_phone:phone.text,
      user_email:email.text,
      department_id: departmentId,
      user_description: description.text,
      user_name: username.text,
      user_id: userId,
      updated: 2,
        create_at:DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'","en").format(DateTime.now()),
        create_by:create_by,
      api: 1,
      isAdmin: isAdmin
    );
    await _databaseHelper.insertToTableDB("users", users.toMap());
  }
  Future<void> updateEmployees()async{
    await _databaseHelper.updateItemTabletDb("users", users!.id,
        "user_phone='${phone.text}',department_id=$departmentId,user_description='${description.text}',"
            "isAdmin='${isAdmin?1:0}',user_name='${username.text}' , updated=0 ");
  }
  setUpdateData(Users users){
    this.users=users;
    email.text = users.user_email.toString();
    username.text = users.user_name.toString();
    password.text = users.user_password.toString();
    description.text = users.user_description.toString();
    phone.text = users.user_phone.toString();
    isAdmin=users.isAdmin==1?true:false;
    for(int i=0;i<departmentList.length;i++){
      if(departmentList[i][0]==users.department_id){
        departmentIndex=i;
        departmentName=departmentList[i][1];
      }
    }
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

  Future<List<Task>> getTaskTypeFromDb(type,create_by)async{
    if(type==1){
      return await _databaseHelper.retrieveTaskFromDb('SELECT * FROM task where create_by="$create_by" AND  emp_id="$create_by"');
    }else if(type==2){
      return await _databaseHelper.retrieveTaskFromDb('SELECT * FROM task where create_by !="$create_by" AND  emp_id="$create_by"');
    }else{
      return await _databaseHelper.retrieveTaskFromDb('SELECT * FROM task where create_by="$create_by" AND  emp_id !="$create_by"');
    }
  }

  List<Users> employeesList =[];
  List<Users> _employeesList =[];
  Future<void> getEmployeesFromDb()async{
    employeesList= await _databaseHelper.retrieveUsersFromDb('SELECT * FROM users');
    _employeesList=employeesList;
    notifyListeners();
  }
  void departmentFilter(String enteredKeyword) {
    List<Users> results = [];
    if (enteredKeyword.isEmpty) {
      results = _employeesList;
    } else {
      results = _employeesList
          .where((user) =>
          user.user_name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    departmentList=results;
    notifyListeners();
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
  Future<void> deleteWithFirebase(userId) async {
  //  CollectionReference collectionRef = FirebaseFirestore.instance.collection('Users');
//    await collectionRef.doc(userId).delete();

//    final UserCredential authResult =await FirebaseAuth.instance.currentUser;
  //  final User? user = authResult.user;
   // print(user!.email);
    notifyListeners();
  }
  deleteUsers(Users user,delete_by,index) async {
    DeletedItem deletedItem=DeletedItem(
      delete_at: DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", "en").format(DateTime.now()),
      delete_by: delete_by,
      item_type: 1,
      online_id:user.user_id,
      api: 1,);
    await _databaseHelper.insertToTableDB("deleted_item", deletedItem.toMap());
    await _databaseHelper.deleteItemsInTableDb("users", user.id);
    employeesList.removeAt(index);
    notifyListeners();
  }
  Future<void> userSetupWithFirebase(create_by) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
     userId = auth.currentUser!.uid.toString();
    DocumentReference docRef = await users.add({'user_name': username.text, 'user_id': userId,"user_phone":phone.text,"user_email":email.text,"user_password":password.text,
      "isAdmin":isAdmin,"user_description":description.text,"department_id":departmentId,"create_by":create_by,"create_at":DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'","en").format(DateTime.now()),});
    await docRef.update({'id': docRef.id});
    notifyListeners();
    return;
  }
}