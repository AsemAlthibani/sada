import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sada/model/database_model/note.dart';
import 'package:sada/model/database_model/users.dart';
import '../../model/database_helper.dart';
import '../../model/database_model/department.dart';
import '../../model/database_model/employees.dart';
import '../../model/database_model/reports_uploaded.dart';
import '../../model/database_model/task.dart';


class GetDataFirestoreController extends ChangeNotifier {
  final DatabaseHelper _databaseHelper=DatabaseHelper();


  Future<void> updateEmployeesData(isAdmin)async{
    List jsonData=[];
    List<Employees> newData=[];
    List<Users> newDataUser=[];
    List<Employees> addData = [];
    List<Users> addDataUsers = [];
    List<Employees> oldData = await _databaseHelper.retrieveEmployeesFromDb('SELECT * FROM employees');
    List<Users> oldDataUsers = await _databaseHelper.retrieveUsersFromDb('SELECT * FROM users');
    if(isAdmin){
     await FirebaseFirestore.instance.collection('Users').get().then((QuerySnapshot querySnapshot) => {
       querySnapshot.docs.forEach((doc) {
         jsonData.add(doc.data());
       }),
     });
     for (var json in jsonData) {
       newDataUser.add(Users.fromMapUpdate(json));
     }
     for (var item in newDataUser) {
       List<Users> results = oldDataUsers.where((user) =>
           user.user_id.toString().toLowerCase().contains(item.user_id.toString().toLowerCase())).toList();
       if (results.isEmpty) {
         addDataUsers.add(item);
       }
     }
     await _databaseHelper.updateDatabase("users",addDataUsers);
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
    for (var item in newData) {
      List<Employees> results = oldData.where((user) =>
          user.user_id.toString().toLowerCase().contains(item.user_id.toString().toLowerCase())).toList();
      if (results.isEmpty) {
        addData.add(item);
      }
    }
    await _databaseHelper.updateDatabase("employees",addData);
  }
  Future<void> getTaskFromFirebase(userId)async{

    List jsonData=[];
    List<Task> newData=[];
    List<Task> addData = [];
    List<Task> oldData = await _databaseHelper.retrieveTaskFromDb('SELECT * FROM task');
    var collectionReference = FirebaseFirestore.instance.collection('TaskEmployees');
    await collectionReference.where("emp_id" ,isNotEqualTo: userId).where("create_by" ,isEqualTo: userId).where("enable_admin",isEqualTo: true).get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        jsonData.add(doc.data());
      }),
    });
    await collectionReference.where("emp_id" ,isEqualTo: userId).where("create_by" ,isNotEqualTo: userId).where("enable_admin" ,isEqualTo: true)
        .get().then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.forEach((doc) {
          jsonData.add(doc.data());
        }),
      });

    for (var json in jsonData) {
      newData.add(Task.froEmpMap(json));
    }
    for (var item in newData) {
      List<Task> results = oldData.where((user) =>
          user.online_id.toString().toLowerCase().contains(item.online_id.toString().toLowerCase())).toList();
      if (results.isEmpty) {
        addData.add(item);
      }
    }
    await _databaseHelper.updateDatabase("task",addData);
  }
  Future<void> getNoteFromFirebase(userId)async{
    List jsonData=[];
    List<AdminNote> newData=[];
    List<AdminNote> addData = [];
    List<AdminNote> oldData = await _databaseHelper.retrieveAdminNoteFromDb('SELECT * FROM admin_note');
    var collectionReference = FirebaseFirestore.instance.collection('AdminNote');
    await collectionReference.where("emp_id" ,isEqualTo: userId).get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        jsonData.add(doc.data());
      }),
    });
    for (var json in jsonData) {
      newData.add(AdminNote.fromMapGet(json));
    }
    for (var item in newData) {
      List<AdminNote> results = oldData.where((user) =>
          user.online_id.toString().toLowerCase().contains(item.online_id.toString().toLowerCase())).toList();
      if (results.isEmpty) {
        addData.add(item);
      }
    }
    await _databaseHelper.updateDatabase("admin_note",addData);
  }
  Future<void> getTaskForAdminFromFirebase()async{
    List jsonData=[];
    List<Task> newData=[];
    List<Task> oldData = await _databaseHelper.retrieveTaskFromDb('SELECT * FROM task');
    List<Task> addData = [];
    var collectionReference = FirebaseFirestore.instance.collection('TaskEmployees');
    await collectionReference.where("for_admin" ,isEqualTo: true)
        .get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        jsonData.add(doc.data());
      }),
    });
    for (var json in jsonData) {
      print("${json["completion_rate"]} completion_rate");
      newData.add(Task.fromMapAdmin(json));
    }
    for (var item in newData) {
      List<Task> results = oldData.where((user) =>
          user.online_id.toString().toLowerCase().contains(item.online_id.toString().toLowerCase())).toList();
      if (results.isEmpty) {
        addData.add(item);
      }
    }
    await _databaseHelper.updateDatabase("task",addData);
  }
  Future<void> getDepartmentFromFirebase()async{
    List jsonData=[];
    List<Department> oldData = await _databaseHelper.retrieveDepartmentFromDb('SELECT * FROM department');
    List<Department> newData=[];
    List<Department> addData=[];
    await FirebaseFirestore.instance.collection('Department').get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        jsonData.add(doc.data());
      }),
    });
    for (var json in jsonData) {
      newData.add(Department.fromMapGet(json));
    }
    for (var item in newData) {
      List<Department> results = oldData.where((user) =>
          user.online_id.toString().toLowerCase().contains(item.online_id.toString().toLowerCase())).toList();
      if (results.isEmpty) {
        addData.add(item);
      }
    }
    await _databaseHelper.updateDatabase("department",addData);
  }
  Future<void> addReportsUploaded(userId,isAdmin)async{
    List jsonData=[];
    List<ReportsUploaded> oldData = await _databaseHelper.retrieveReportsUploadedFromDb('SELECT * FROM reports_uploaded');
    List<ReportsUploaded> newData=[];
    List<ReportsUploaded> addData=[];
    var collectionReference = FirebaseFirestore.instance.collection('ReportsUploaded');
    await collectionReference.get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        jsonData.add(doc.data());
      }),
    });
    for (var json in jsonData) {
      newData.add(ReportsUploaded.fromMapGet(json));
    }
    for (var item in newData) {
      List<ReportsUploaded> results = oldData.where((user) =>
          user.online_id.toString().toLowerCase().contains(item.online_id.toString().toLowerCase())).toList();
      if (results.isEmpty) {
        addData.add(item);
      }
    }
    await _databaseHelper.updateDatabase("reports_uploaded",addData);
  }

  Future<void> postDataToFirebase(userId,isAdmin)async{
    await updateEmployeesData(isAdmin);
    await addReportsUploaded(userId,isAdmin);
    await getTaskFromFirebase(userId);
    await getNoteFromFirebase(userId);
    if(isAdmin){
      await getTaskForAdminFromFirebase();
      await getDepartmentFromFirebase();
    }
  }
}