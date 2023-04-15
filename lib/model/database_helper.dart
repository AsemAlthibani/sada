
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_model/department.dart';
import 'database_model/employees.dart';
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
  `task_name` varchar(255) DEFAULT NULL,
  `date` TEXT DEFAULT NULL,
  `task_description` varchar(255) DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `create_by` int DEFAULT NULL,
  `start_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completion_rate` decimal(25,2) NOT NULL DEFAULT '0.00',
  `task_completed` tinyint(1) DEFAULT '0',
  `updated` tinyint(1) NOT NULL DEFAULT '1',
  `api` tinyint(1) DEFAULT '0'
  );
  '''
      );
      db.execute(
          '''
   CREATE TABLE `users` (
  `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `user_id` varchar(255) DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `user_description` varchar(255) DEFAULT NULL,
  `user_email` varchar(255) DEFAULT NULL,
  `user_phone` varchar(255) DEFAULT NULL,
  `user_password` varchar(255) DEFAULT NULL,
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
  `department_name` varchar(255) DEFAULT NULL,
  `updated` tinyint(1) NOT NULL DEFAULT '1',
  `api` tinyint(1) DEFAULT '0'
    );
  '''
      );
      db.execute(
          '''
   CREATE TABLE `employees` (
  `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `employees_name` varchar(255) DEFAULT NULL,
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
         CREATE TABLE `note` (
  `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `note_description` varchar(255) DEFAULT NULL,
  `isAdmin` tinyint(1) NOT NULL DEFAULT '0',
`user_id` int DEFAULT NULL,
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
    await _db.insert(
      tableName,
      tableMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return taskId;
  }
  Future<List<Department>> retrieveDepartmentFromDb() async {
    Database db = await initializeRestaurantDb();
    List<Map<String, dynamic>> taskMap = await db.rawQuery('SELECT * FROM department');
    return List.generate(taskMap.length, (index) {
      return Department(id: taskMap[index]['id'], department_name: taskMap[index]['department_name'],
          updated: taskMap[index]['updated'],api: taskMap[index]['api'] );
    });
  }
  Future<List<Employees>> retrieveEmployeesFromDb() async {
    Database db = await initializeRestaurantDb();
    List<Map<String, dynamic>> taskMap = await db.rawQuery('SELECT * FROM employees');
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
  Future<List<Users>> retrieveUsersFromDb() async {
    Database db = await initializeRestaurantDb();
    List<Map<String, dynamic>> taskMap = await db.rawQuery('SELECT * FROM users');
    return List.generate(taskMap.length, (index) {
      return Users(
        id: taskMap[index]["id"],
        user_password: taskMap[index]["user_password"],
        user_phone: taskMap[index]["user_phone"],
        user_email: taskMap[index]["user_email"],
        department_id: taskMap[index]["department_id"],
        user_description: taskMap[index]["user_description"],
        user_name: taskMap[index]["user_name"],
        user_id: taskMap[index]["user_id"],
        updated: taskMap[index]["updated"],
        api: taskMap[index]["api"],
        isAdmin: taskMap[index]["isAdmin"],
      );
    });
  }
  Future<List<Task>> retrieveTaskFromDb() async {
    Database db = await initializeRestaurantDb();
    List<Map<String, dynamic>> taskMap = await db.rawQuery('SELECT * FROM task');
    return List.generate(taskMap.length, (index) {
      return Task(id: taskMap[index]["id"],
          task_name: taskMap[index]["task_name"],
          task_description: taskMap[index]["task_description"],
          user_id: taskMap[index]["user_id"],
          date: taskMap[index]["date"],
          create_by: taskMap[index]["create_by"],
          department_id: taskMap[index]["department_id"],
          end_date: taskMap[index]["end_date"],
          start_date: taskMap[index]["start_date"],
          task_completed: taskMap[index]["task_completed"],
          completion_rate: taskMap[index]["completion_rate"],
          updated: taskMap[index]["updated"],
          api: taskMap[index]["api"]
      );
    });
  }
  Future<List<Task>> retrieveTaskToFirebaseFromDb() async {
    Database db = await initializeRestaurantDb();
    List<Map<String, dynamic>> taskMap = await db.rawQuery('SELECT * FROM task where api=0 ');
    return List.generate(taskMap.length, (index) {
      return Task(id: taskMap[index]["id"],
          task_name: taskMap[index]["task_name"],
          task_description: taskMap[index]["task_description"],
          user_id: taskMap[index]["user_id"],
          date: taskMap[index]["date"],
          create_by: taskMap[index]["create_by"],
          department_id: taskMap[index]["department_id"],
          end_date: taskMap[index]["end_date"],
          start_date: taskMap[index]["start_date"],
          task_completed: taskMap[index]["task_completed"],
          completion_rate: taskMap[index]["completion_rate"],
          updated: taskMap[index]["updated"],
          api: taskMap[index]["api"]
      );
    });
  }
  Future<List<Task>> retrieveTaskToFirebaseUpdateFromDb() async {
    Database db = await initializeRestaurantDb();
    List<Map<String, dynamic>> taskMap = await db.rawQuery('SELECT * FROM task where updated=0 ');
    return List.generate(taskMap.length, (index) {
      return Task(id: taskMap[index]["id"],
          task_name: taskMap[index]["task_name"],
          task_description: taskMap[index]["task_description"],
          user_id: taskMap[index]["user_id"],
          date: taskMap[index]["date"],
          create_by: taskMap[index]["create_by"],
          department_id: taskMap[index]["department_id"],
          end_date: taskMap[index]["end_date"],
          start_date: taskMap[index]["start_date"],
          task_completed: taskMap[index]["task_completed"],
          completion_rate: taskMap[index]["completion_rate"],
          updated: taskMap[index]["updated"],
          api: taskMap[index]["api"]
      );
    });
  }
  Future<List<Task>> retrieveTaskCreateByAdminFromDb(create_by) async {
    Database db = await initializeRestaurantDb();
    List<Map<String, dynamic>> taskMap = await db.rawQuery('SELECT * FROM task where create_by !="$create_by" AND  user_id="$create_by"');
    return List.generate(taskMap.length, (index) {
      return Task(id: taskMap[index]["id"],
          task_name: taskMap[index]["task_name"],
          task_description: taskMap[index]["task_description"],
          user_id: taskMap[index]["user_id"],
          date: taskMap[index]["date"],
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
  Future<List<Task>> retrieveTaskCreateByUserFromDb(create_by) async {
    Database db = await initializeRestaurantDb();
    List<Map<String, dynamic>> taskMap = await db.rawQuery('SELECT * FROM task where create_by="$create_by" ');
    return List.generate(taskMap.length, (index) {
      return Task(id: taskMap[index]["id"],
          task_name: taskMap[index]["task_name"],
          task_description: taskMap[index]["task_description"],
          user_id: taskMap[index]["user_id"],
          date: taskMap[index]["date"],
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
  Future<void> deleteSequenceItemsDb(tablename) async{
    Database db = await initializeRestaurantDb();
    await db.rawQuery("delete from sqlite_sequence where name='$tablename' ");
  }
}