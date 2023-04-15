import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/database_helper.dart';
import '../../model/database_model/employees.dart';
import '../../model/database_model/task.dart';


class GetDataFirestoreController extends ChangeNotifier {
  final DatabaseHelper _databaseHelper=DatabaseHelper();

  Future<void> postTaskToFirebase()async{
    List<Task> taskList = await _databaseHelper.retrieveTaskFromDb('SELECT * FROM task where api=0 ');
    var taskMap = taskList.map((dynamic) =>
    {
      'offline_id': dynamic.id,
      'task_name': dynamic.task_name,
      'task_description': dynamic.task_description,
      'department_id': dynamic.department_id,
      'end_date': dynamic.end_date,
      'date': dynamic.date,
      "not": dynamic.not,
      "enable_admin": dynamic.enable_admin==1?true:false,
      'start_date':dynamic.start_date,
      'task_completed': dynamic.task_completed==1?true:false,
      'for_admin': dynamic.for_admin==1?true:false,
      'create_by': dynamic.create_by,
      'completion_rate': dynamic.completion_rate,
      'emp_name': dynamic.emp_name,
      'emp_id': dynamic.emp_id,
      'create_by_name': dynamic.create_by_name,
      "updated": dynamic.updated,
      "api": dynamic.api,
      "emp_add": false,
      "admin_add": false,
    }).toList();

    CollectionReference collectionRef = FirebaseFirestore.instance.collection('TaskEmployees');
    List documentIds = [];
    for (Map<String, dynamic> data in taskMap) {
      print(data["offline_id"]);
      DocumentReference docRef = await collectionRef.add(data);
      documentIds.add([docRef.id,data["offline_id"]]);
      await docRef.update({'id': docRef.id});
    }
    for(var data in documentIds){
      await _databaseHelper.updateItemTabletDb("task", data[1], "api=1,online_id='${data[0]}'");
    }
  }
  Future<void> postTaskUpdateToFirebase()async{
    List<Task> taskList = await _databaseHelper.retrieveTaskFromDb('SELECT * FROM task where updated=0 ');
    var taskMap = taskList.map((dynamic) =>
    {
      'offline_id': dynamic.id,
      'task_name': dynamic.task_name,
      'task_description': dynamic.task_description,
      'department_id': dynamic.department_id,
      'end_date': dynamic.end_date,
      'date': dynamic.date,
      "not": dynamic.not,
      "enable_admin": dynamic.enable_admin==1?true:false,
      'start_date':dynamic.start_date,
      'task_completed': dynamic.task_completed==1?true:false,
      'for_admin': dynamic.for_admin==1?true:false,
      'create_by': dynamic.create_by,
      'completion_rate': dynamic.completion_rate,
      'emp_name': dynamic.emp_name,
      'emp_id': dynamic.emp_id,
      'create_by_name': dynamic.create_by_name,
      "updated": dynamic.updated,
      "api": dynamic.api,
      "emp_add": false,
      "admin_add": false,
    }).toList();
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('TaskEmployees');
    List documentIds = [];
    for (Map<String, dynamic> data in taskMap) {
      print(data["offline_id"]);
      DocumentReference docRef = await collectionRef.add(data);
      documentIds.add([docRef.id,data["offline_id"]]);
      await docRef.update({'id': docRef.id});
    }
    for(var data in documentIds){
      await _databaseHelper.updateItemTabletDb("task", data[1], "api=1,online_id='${data[0]}'");
    }
  }
  Future<void> updateEmployeesData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? isAdmin=preferences.getBool("isAdmin");
    isAdmin??=false;
    List jsonData=[];
    await _databaseHelper.deleteItemsDb("employees");
    await _databaseHelper.deleteSequenceItemsDb("employees");
    List<Employees> newData=[];
   if(isAdmin){
     await FirebaseFirestore.instance.collection('Users').get().then((QuerySnapshot querySnapshot) => {
       querySnapshot.docs.forEach((doc) {
         jsonData.add(doc.data());
       }),
     });
   }else{
     await FirebaseFirestore.instance.collection('Users').where("isAdmin" ,isEqualTo: false).get().then((QuerySnapshot querySnapshot) => {
       querySnapshot.docs.forEach((doc) {
         jsonData.add(doc.data());
       }),
     });
   }
    for (var json in jsonData) {
      newData.add(Employees.fromMapUpdate(json));
    }
    await _databaseHelper.updateDatabase("employees",newData);
  }
  Future<void> getTaskFromFirebase(userId)async{
    List jsonData=[];
    List<Task> newData=[];
    var collectionReference = FirebaseFirestore.instance.collection('TaskEmployees');
    await collectionReference.where("emp_add" ,isEqualTo: false)
    .where("emp_id" ,isEqualTo: userId).where("create_by" ,isNotEqualTo: userId).where("enable_admin" ,isEqualTo: true)
        .get().then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.forEach((doc) {
          jsonData.add(doc.data());
        }),
      });
    for (var json in jsonData) {
      newData.add(Task.froEmpMap(json));
    }
    await _databaseHelper.updateDatabase("task",newData);
  }
  Future<void> getTaskForAdminFromFirebase()async{
    List jsonData=[];
    List<Task> newData=[];
    var collectionReference = FirebaseFirestore.instance.collection('TaskEmployees');
    await collectionReference.where("for_admin" ,isEqualTo: true).where("admin_add" ,isEqualTo: false)
        .where("enable_admin" ,isEqualTo: false)
        .get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        jsonData.add(doc.data());
      }),
    });
    for (var json in jsonData) {
      print("${json["completion_rate"]} completion_rate");
      newData.add(Task.fromMapAdmin(json));
    }
    await _databaseHelper.updateDatabase("task",newData);
    for (var json in jsonData) {
      collectionReference.doc(json["id"]).update({
        'admin_add': true
      }).then((value) => print("Document updated")).catchError((error) => print("Failed to update document: $error"));
    }
  }
  postDataToFirebase(userId,isAdmin)async{
    await Firebase.initializeApp();
    await postTaskToFirebase();
    await updateEmployeesData();
    await getTaskFromFirebase(userId);
    if(isAdmin){
    await getTaskForAdminFromFirebase();
    }
  }
}