import 'package:flutter/material.dart';
import '../responsive_layout.dart';
import '../small_screen/admin/add_employees_screen.dart';
import '../small_screen/admin/admin_menu_screen.dart';
import '../small_screen/admin/admin_task_screen.dart';
import '../small_screen/admin/department_screen.dart';
import '../small_screen/admin/employees_screen.dart';
import '../small_screen/login/login_screen.dart';
import '../small_screen/user/add_task_screen.dart';
import '../small_screen/user/menu_screen.dart';
import '../small_screen/user/settings_screen.dart';
import '../small_screen/user/task_details_screen.dart';
import '../small_screen/user/task_screen.dart';



class AdminMenuScreenLanding extends StatelessWidget {
  const AdminMenuScreenLanding({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: AdminMenuScreen(),
        tabletBody:  AdminMenuScreen());
  }
}
class MenuScreenLanding extends StatelessWidget {
  const MenuScreenLanding({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: MenuScreen(),
        tabletBody:  MenuScreen());
  }
}
class AddTaskScreenLanding extends StatelessWidget {
  const AddTaskScreenLanding({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: AddTaskScreen(),
        tabletBody:  AddTaskScreen());
  }
}
class EmployeesScreenLanding extends StatelessWidget {
  const EmployeesScreenLanding({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: EmployeesScreen(),
        tabletBody:  EmployeesScreen());
  }
}
class DepartmentScreenLanding extends StatelessWidget {
  const DepartmentScreenLanding({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: DepartmentScreen(),
        tabletBody:  DepartmentScreen());
  }
}
class SettingsScreenLanding extends StatelessWidget {
  const SettingsScreenLanding({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: SettingsScreen(),
        tabletBody:  SettingsScreen());
  }
}
class EmployeesAddScreenLanding extends StatelessWidget {
  const EmployeesAddScreenLanding({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: EmployeesAddScreen(),
        tabletBody:  EmployeesAddScreen());
  }
}
class AllTaskScreenLanding extends StatelessWidget {
  const AllTaskScreenLanding({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: TaskScreen(),
        tabletBody:  TaskScreen());
  }

}
class AdminTaskScreenLanding extends StatelessWidget {
  const AdminTaskScreenLanding({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: AdminTaskScreen(),
        tabletBody:  AdminTaskScreen());
  }
}
class TaskDetailsScreenLanding extends StatelessWidget {
  final bool? adminShare;
  const TaskDetailsScreenLanding({Key? key,this.adminShare}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: TaskDetailsScreen(adminShare:adminShare),
        tabletBody:  TaskDetailsScreen(adminShare:adminShare));
  }
}