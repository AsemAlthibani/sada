import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:sada/model/database_model/deleted_item.dart';
import 'package:sada/model/database_model/users.dart';
import '../../model/database_helper.dart';
import '../../model/database_model/department.dart';
import '../../model/database_model/note.dart';
import '../../model/database_model/task.dart';


class PostDataFirestoreController extends ChangeNotifier {
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
      "api": 1,
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
  Future<void> postDeleteTaskToFirebase()async{
    List<DeletedItem> deletedItemList = await _databaseHelper.retrieveDeletedItemFromDb('SELECT * FROM deleted_item where item_type=1 and api=0 ');
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('TaskEmployees');
    for (var data in deletedItemList) {
      print(data.online_id);
    await collectionRef.doc(data.online_id).delete();
    }
    for(var data in deletedItemList){
      await _databaseHelper.updateItemTabletDb("deleted_item", data.id, "api=1");
    }
  }
  Future<void> postDeleteUserFirebase()async{
    List<DeletedItem> deletedItemList = await _databaseHelper.retrieveDeletedItemFromDb('SELECT * FROM deleted_item where item_type=2 and api=0 ');
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('Users');
    for (var data in deletedItemList) {
      print(data.online_id);
      await collectionRef.doc(data.online_id).delete();
    }
    for(var data in deletedItemList){
      await _databaseHelper.updateItemTabletDb("deleted_item", data.id, "api=1");
    }
  }
  Future<void> postDeleteReportsUploadedFirebase()async{
    List<DeletedItem> deletedItemList = await _databaseHelper.retrieveDeletedItemFromDb('SELECT * FROM deleted_item where item_type=3 and api=0 ');
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('ReportsUploaded');
    for (var data in deletedItemList) {
      print(data.online_id);
      await collectionRef.doc(data.online_id).delete();
    }
    for(var data in deletedItemList){
      await _databaseHelper.updateItemTabletDb("deleted_item", data.id, "api=1");
    }
  }
  Future<void> postDeleteDepartmentFirebase()async{
    List<DeletedItem> deletedItemList = await _databaseHelper.retrieveDeletedItemFromDb('SELECT * FROM deleted_item where item_type=4 and api=0 ');
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('Department');
    for (var data in deletedItemList) {
      print(data.online_id);
      await collectionRef.doc(data.online_id).delete();
    }
    for(var data in deletedItemList){
      await _databaseHelper.updateItemTabletDb("deleted_item", data.id, "api=1");
    }
  }
  Future<void> postDepartmentToFirebase()async{
    List<Department> departmentList = await _databaseHelper.retrieveDepartmentFromDb('SELECT * FROM department where api=0');
    var taskMap = departmentList.map((dynamic) =>
    {
      'offline_id': dynamic.id,
      'department_name': dynamic.department_name,
      'create_by': dynamic.create_by,
      'create_at': dynamic.create_at,
      "updated": dynamic.updated,
      "api": 1,
      "admin_add": false,
    }).toList();

    CollectionReference collectionRef = FirebaseFirestore.instance.collection('Department');
    List documentIds = [];
    for (Map<String, dynamic> data in taskMap) {
      print(data["offline_id"]);
      DocumentReference docRef = await collectionRef.add(data);
      documentIds.add([docRef.id,data["offline_id"]]);
      await docRef.update({'id': docRef.id});
    }
    for(var data in documentIds){
      await _databaseHelper.updateItemTabletDb("department", data[1], "api=1,online_id='${data[0]}'");
    }
  }
  Future<void> postAdminNoteToFirebase()async{
    List<AdminNote> departmentList = await _databaseHelper.retrieveAdminNoteFromDb('SELECT * FROM admin_note where api=0');
    var taskMap = departmentList.map((dynamic) =>
    {
      'offline_id': dynamic.id,
      'note_description': dynamic.note_description,
      'emp_id': dynamic.emp_id,
      "updated": dynamic.updated,
      "isAdmin": dynamic.isAdmin,
      "note_type": dynamic.note_type,
      "api": dynamic.api,
      "reports_id": dynamic.reports_id,
      "create_by": dynamic.create_by,
      "create_by_name": dynamic.create_by_name,
      "emp_name": dynamic.emp_name,
      "date": dynamic.date,
      "emp_add": false,
    }).toList();

    CollectionReference collectionRef = FirebaseFirestore.instance.collection('AdminNote');
    List documentIds = [];
    for (Map<String, dynamic> data in taskMap) {
      print(data["offline_id"]);
      DocumentReference docRef = await collectionRef.add(data);
      documentIds.add([docRef.id,data["offline_id"]]);
      await docRef.update({'id': docRef.id});
    }
    for(var data in documentIds){
      await _databaseHelper.updateItemTabletDb("admin_note", data[1], "api=1,online_id='${data[0]}'");
    }
  }
  Future<void> updateTaskToFirebase()async{
    List<Task> taskList = await _databaseHelper.retrieveTaskFromDb('SELECT * FROM task where updated=0 ');
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('TaskEmployees');
    for (var dynamic in taskList) {
      await collectionRef.doc(dynamic.online_id).update({
        'task_name': dynamic.task_name,
        'task_description': dynamic.task_description,
        'end_date': dynamic.end_date,
        'start_date':dynamic.start_date,
        'task_completed': dynamic.task_completed==1?true:false,
        'completion_rate': dynamic.completion_rate,
      }).then((value) => print("TaskEmployees updated")).catchError((error) => print("Failed to update document: $error"));
    }
    for(var data in taskList){
      await _databaseHelper.updateItemTabletDb("task", data.id, "updated=1");
    }
  }
  Future<void> updateDepartmentToFirebase()async{
    List<Department> taskList = await _databaseHelper.retrieveDepartmentFromDb('SELECT * FROM department where updated=0 ');
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('Department');
    for (var dynamic in taskList) {
      await collectionRef.doc(dynamic.online_id).update({
        'department_name': dynamic.department_name,
      }).then((value) => print("TaskEmployees updated")).catchError((error) => print("Failed to update document: $error"));
    }
    for(var data in taskList){
      await _databaseHelper.updateItemTabletDb("department", data.id, "updated=1");
    }
  }
  Future<void> updateUsersToFirebase()async{
    List<Users> taskList = await _databaseHelper.retrieveUsersFromDb('SELECT * FROM users where updated=0  ');
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('Users');
    for (var dynamic in taskList) {
      await collectionRef.doc(dynamic.online_id).update({
        "user_phone":dynamic.user_phone,
        "department_id": dynamic.department_id,
        "user_description": dynamic.user_description,
        "user_name":dynamic.user_name,
        "isAdmin": dynamic.isAdmin,
      }).then((value) => print("TaskEmployees updated")).catchError((error) => print("Failed to update document: $error"));
    }
    for(var data in taskList){
      await _databaseHelper.updateItemTabletDb("users", data.id, "updated=1");
    }
  }
  Future<void> updateTaskForAdminFromFirebase()async{
    List<Task> taskList = await _databaseHelper.retrieveTaskFromDb('SELECT * FROM task where updated = 0 ');
    print("${taskList.last.task_description} task_description");
    var collectionReference = FirebaseFirestore.instance.collection('TaskEmployees');
    for (var json in taskList) {
      print(json.online_id);
      await collectionReference.doc(json.online_id).update({
        "not": json.not,
        "enable_admin": json.enable_admin==1?true:false,
      }).then((value) => print("TaskEmployees updated")).catchError((error) => print("Failed to update TaskEmployees: $error"));
    }
    for(var data in taskList){
      await _databaseHelper.updateItemTabletDb("task", data.id, "updated=1");
    }
  }
  Future<void> postDataToFirebase(userId,isAdmin)async{
    await Firebase.initializeApp();
    await postTaskToFirebase();
    if(isAdmin){
      await postDeleteDepartmentFirebase();
      await postDeleteTaskToFirebase();
      await postDeleteReportsUploadedFirebase();
      await postDepartmentToFirebase();
      await postAdminNoteToFirebase();
      await updateTaskForAdminFromFirebase();
    }
    await updateTaskToFirebase();
  }
}