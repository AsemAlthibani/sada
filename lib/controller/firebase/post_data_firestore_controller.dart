import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../model/database_helper.dart';
import '../../model/database_model/task.dart';


class PostDataFirestoreController extends ChangeNotifier {
  final DatabaseHelper _databaseHelper=DatabaseHelper();

  postTaskToFirebase()async{
    List<Task> taskList = await _databaseHelper.retrieveTaskToFirebaseFromDb();
    final CollectionReference profileList = FirebaseFirestore.instance.collection("TaskEmployees");
    return await profileList.doc().set(taskList);
  }
  updateTaskToFirebase()async{
    List<Task> taskList = await _databaseHelper.retrieveTaskToFirebaseUpdateFromDb();
    final CollectionReference profileList = FirebaseFirestore.instance.collection("TaskEmployees");
//    return await profileList.doc().update(taskList);
  }
}