
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_model/deleted_item.dart';
import 'database_model/department.dart';
import 'database_model/employees.dart';
import 'database_model/note.dart';
import 'database_model/reports_uploaded.dart';
import 'database_model/task.dart';
import 'database_model/users.dart';


class DatabaseHelper {

  Future<Database> initializeRestaurantDb() async {
    Future<Database> db = openDatabase(
        join(await getDatabasesPath(), 'olive.db'), onCreate: (db, version) {
      db.execute(
          '''
   CREATE TABLE `task` (
  `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `online_id` TEXT DEFAULT NULL,
  `task_name` TEXT DEFAULT NULL,
  `date` TEXT DEFAULT NULL,
  `task_description` TEXT DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  `emp_id` int DEFAULT NULL,
  `emp_name` TEXT DEFAULT NULL,
  `create_by` TEXT DEFAULT NULL,
  `create_by_name` TEXT DEFAULT NULL,
  `start_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completion_rate` decimal(25,2) NOT NULL DEFAULT '0.00',
  `task_completed` tinyint(1) DEFAULT '0',
  `enable_admin` tinyint(1) NOT NULL DEFAULT '0',
  `not` TEXT DEFAULT NULL,
  `updated` tinyint(1) NOT NULL DEFAULT '1',
  `new_add` tinyint(1) NOT NULL DEFAULT '1',
  `for_admin` tinyint(1) NOT NULL DEFAULT '0',
  `api` tinyint(1) DEFAULT '0'
  );
  '''
      );
      db.execute(
          '''
   CREATE TABLE `reports_uploaded` (
  `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `online_id` TEXT DEFAULT NULL,
  `file_name` TEXT DEFAULT NULL,
  `file_path` TEXT DEFAULT NULL,
  `file_url` TEXT DEFAULT NULL,  
  `date` TEXT DEFAULT NULL,
  `create_by` TEXT DEFAULT NULL,
  `isAdmin` tinyint(1) NOT NULL DEFAULT '0',
  `downloaded` tinyint(1) NOT NULL DEFAULT '0',
  `create_by_name` TEXT DEFAULT NULL,
  `not` TEXT DEFAULT NULL,
  `new_add` tinyint(1) NOT NULL DEFAULT '1',
  `api` tinyint(1) DEFAULT '0'
  );
  '''
      );
      db.execute(
          '''
   CREATE TABLE `users` (
  `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `user_id` TEXT DEFAULT NULL,
  `department_id` int DEFAULT NULL,
    `create_by` TEXT DEFAULT NULL,
  `online_id` TEXT DEFAULT NULL,
    `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_name` TEXT DEFAULT NULL,
  `user_description` TEXT DEFAULT NULL,
  `user_email` TEXT DEFAULT NULL,
  `user_phone` TEXT DEFAULT NULL,
  `user_password` TEXT DEFAULT NULL,
  `isAdmin` tinyint(1) NOT NULL DEFAULT '0',
  `updated` tinyint(1) NOT NULL DEFAULT '1',
  `api` tinyint(1) DEFAULT '0'
  );
  '''
      );
      db.execute(
          '''
   CREATE TABLE `department` (
  `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `department_name` TEXT DEFAULT NULL,
   `create_by` TEXT DEFAULT NULL,
   `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `online_id` TEXT DEFAULT NULL,
  `updated` tinyint(1) NOT NULL DEFAULT '1',
  `api` tinyint(1) DEFAULT '0'
    );
  '''
      );
      db.execute(
          '''
   CREATE TABLE `deleted_item` (
  `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `item_type` int DEFAULT NULL,
  `delete_by` TEXT DEFAULT NULL,
  `delete_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `online_id` TEXT DEFAULT NULL,
  `api` tinyint(1) DEFAULT '0'
    );
  '''
      );
      db.execute(
          '''
   CREATE TABLE `employees` (
  `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `employees_name` TEXT DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  `isAdmin` tinyint(1) NOT NULL DEFAULT '0',
  `updated` tinyint(1) NOT NULL DEFAULT '1',
  `api` tinyint(1) DEFAULT '0'
    );
  '''
      );
      db.execute(
          '''
         CREATE TABLE `admin_note` (
  `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `note_description` TEXT DEFAULT NULL,
  `reports_id` TEXT DEFAULT NULL,
  `isAdmin` tinyint(1) NOT NULL DEFAULT '0',
  `create_by` TEXT DEFAULT NULL,
  `create_by_name` TEXT DEFAULT NULL,
  `online_id` TEXT DEFAULT NULL,
  `note_type` int DEFAULT NULL,
  `emp_name` TEXT DEFAULT NULL,
  `emp_id` TEXT DEFAULT NULL,
  `date` TEXT DEFAULT NULL,
  `new_add` tinyint(1) NOT NULL DEFAULT '1',
  `updated` tinyint(1) NOT NULL DEFAULT '1',
  `api` tinyint(1) DEFAULT '0'
    ); 
      '''
      );

    }, version: 1);
    return db;
  }
  Future<int> insertToTableDB(tableName,tableMap) async {
    int taskId = 0;
    Database _db = await initializeRestaurantDb();
    taskId=await _db.insert(
      tableName,
      tableMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return taskId;
  }
  Future<List<Department>> retrieveDepartmentFromDb(query) async {
    Database db = await initializeRestaurantDb();
    List<Map<String, dynamic>> taskMap = await db.rawQuery(query);
    return List.generate(taskMap.length, (index) {
      return Department(id: taskMap[index]['id'], department_name: taskMap[index]['department_name'],
          create_by: taskMap[index]["create_by"],
          online_id: taskMap[index]["online_id"],
          create_at: taskMap[index]["create_at"],
          updated: taskMap[index]['updated'],api: taskMap[index]['api'] );
    }
  );
  }
  Future<List<AdminNote>> retrieveAdminNoteFromDb(query) async {
    Database db = await initializeRestaurantDb();
    List<Map<String, dynamic>> taskMap = await db.rawQuery(query);
    return List.generate(taskMap.length, (index) {
      return AdminNote(id: taskMap[index]["id"],
        note_description: taskMap[index]["note_description"],
        emp_id: taskMap[index]["emp_id"],
        updated: taskMap[index]["updated"],
        reports_id: taskMap[index]["reports_id"],
        note_type: taskMap[index]["note_type"],
        isAdmin: taskMap[index]["isAdmin"],
        new_add: taskMap[index]["new_add"],
        api: taskMap[index]["api"],
        create_by: taskMap[index]["create_by"],
        online_id: taskMap[index]["online_id"],
        create_by_name: taskMap[index]["create_by_name"],
        emp_name: taskMap[index]["emp_name"],
        date: taskMap[index]["date"],
      );
    }
    );
  }
  Future<List<Employees>> retrieveEmployeesFromDb(query) async {
    Database db = await initializeRestaurantDb();
    List<Map<String, dynamic>> taskMap = await db.rawQuery(query);
    return List.generate(taskMap.length, (index) {
      return Employees(    id: taskMap[index]["id"],
        department_id: taskMap[index]["department_id"],
        employees_name: taskMap[index]["employees_name"],
        user_id: taskMap[index]["user_id"],
        updated: taskMap[index]["updated"],
        isAdmin: taskMap[index]["isAdmin"],
        api: taskMap[index]["api"],
      );
    });
  }
  Future<List<DeletedItem>> retrieveDeletedItemFromDb(query) async {
    Database db = await initializeRestaurantDb();
    List<Map<String, dynamic>> taskMap = await db.rawQuery(query);
    return List.generate(taskMap.length, (index) {
      return  DeletedItem(
        id: taskMap[index]["id"],
        delete_at: taskMap[index]["delete_at"],
        delete_by: taskMap[index]["delete_by"],
        item_type: taskMap[index]["item_type"],
        online_id: taskMap[index]["online_id"],
        api: taskMap[index]["api"],
      );
    });
  }
  Future<List<ReportsUploaded>> retrieveReportsUploadedFromDb(query) async {
    Database db = await initializeRestaurantDb();
    List<Map<String, dynamic>> taskMap = await db.rawQuery(query);
    return List.generate(taskMap.length, (index) {
      return  ReportsUploaded(
        id: taskMap[index]["id"],
        file_name: taskMap[index]["file_name"],
        file_path: taskMap[index]["file_path"],
        file_url: taskMap[index]["file_url"],
        isAdmin: taskMap[index]["isAdmin"],
        downloaded: taskMap[index]["downloaded"],
        date: taskMap[index]["date"],
        not: taskMap[index]["not"],
        online_id: taskMap[index]["online_id"],
        create_by: taskMap[index]["create_by"],
        create_by_name: taskMap[index]["create_by_name"],
        api: taskMap[index]["api"],
        new_add: taskMap[index]["new_add"],
      );
    });
  }
  Future<List<Users>> retrieveUsersFromDb(query) async {
    Database db = await initializeRestaurantDb();
    List<Map<String, dynamic>> taskMap = await db.rawQuery(query);
    return List.generate(taskMap.length, (index) {
      return Users(
        id: taskMap[index]["id"],
        user_password: taskMap[index]["user_password"],
        user_phone: taskMap[index]["user_phone"],
        user_email: taskMap[index]["user_email"],
        online_id: taskMap[index]["online_id"],
        department_id: taskMap[index]["department_id"],
        user_description: taskMap[index]["user_description"],
        create_by: taskMap[index]["create_by"],
        create_at: taskMap[index]["create_at"],
        user_name: taskMap[index]["user_name"],
        user_id: taskMap[index]["user_id"],
        updated: taskMap[index]["updated"],
        api: taskMap[index]["api"],
        isAdmin: taskMap[index]["isAdmin"],
      );
    });
  }

  Future<List<Task>> retrieveTaskFromDb(query) async {
    Database db = await initializeRestaurantDb();
    List<Map<String, dynamic>> taskMap = await db.rawQuery(query);
    return List.generate(taskMap.length, (index) {
      return Task(id: taskMap[index]["id"],
          task_name: taskMap[index]["task_name"],
          task_description: taskMap[index]["task_description"],
          emp_id: taskMap[index]["emp_id"],
          date: taskMap[index]["date"],
          not: taskMap[index]["not"],
          for_admin: taskMap[index]["for_admin"],
          online_id: taskMap[index]["online_id"],
          new_add: taskMap[index]["new_add"],
          enable_admin: taskMap[index]["enable_admin"],
          create_by_name: taskMap[index]["create_by_name"],
          emp_name: taskMap[index]["emp_name"],
          create_by: taskMap[index]["create_by"],
          department_id: taskMap[index]["department_id"],
          end_date: taskMap[index]["end_date"],
          start_date: taskMap[index]["start_date"],
          task_completed: taskMap[index]["task_completed"],
          completion_rate: taskMap[index]["completion_rate"],
          updated: taskMap[index]["updated"],
          api: taskMap[index]["api"]);
    });
  }
  Future<void> updateItemTabletDb(table, id,values) async{
    Database db = await initializeRestaurantDb();
    await db.transaction((txn) {
      return txn.rawQuery("UPDATE $table SET $values where id= $id");
    });
  }
  Future<void> deleteItemsDb(tablename) async{
    Database db = await initializeRestaurantDb();
    await db.rawQuery("delete from '$tablename' ");

  }
  Future<void> deleteItemDatabase(tableName,dataToDelete,where) async {
    Database _db = await initializeRestaurantDb();
    await _db.transaction((txn) async {
      final batch = txn.batch();
      for (var item in dataToDelete) {
        batch.delete(
          tableName,
          where: where,
          whereArgs: [item.id],
        );
      }
      await batch.commit();
    });
  }

  Future<List> deleteItemsInTableDb(tableName,id) async{
    Database db = await initializeRestaurantDb();
    return db.rawQuery('DELETE FROM "$tableName" WHERE  id=$id');
  }
  Future<List> deleteSequenceItemsInTableDb(tableName,id) async{
    Database db = await initializeRestaurantDb();
    return db.rawQuery('DELETE FROM sqlite_sequence WHERE name= "$tableName" AND  id=$id');
  }
  Future<void> deleteSequenceItemsDb(tablename) async{
    Database db = await initializeRestaurantDb();
    await db.rawQuery("delete from sqlite_sequence where name='$tablename' ");
  }
  Future<void> deleteDatabase(tableName,dataToDelete) async {
    Database _db = await initializeRestaurantDb();
    await _db.transaction((txn) async {
      final batch = txn.batch();
      for (var item in dataToDelete) {
        batch.delete(
          tableName,
          where: 'user_id = ?',
          whereArgs: [item.user_id],
        );
      }
      await batch.commit();
    });
  }
  Future<void> updateDatabase(tableName,newData) async {
    Database _db = await initializeRestaurantDb();
    await _db.transaction((txn) async {
      final batch = txn.batch();
      for (var item in newData) {
        batch.insert(
          tableName,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit();
    });
  }
  Future<List> retrieveTaskReportFromDb(query) async{
    Database db = await initializeRestaurantDb();
    return db.rawQuery(query);
  }
}