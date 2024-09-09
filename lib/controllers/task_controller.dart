// import 'package:get/get.dart';
// import 'package:todo_app/database/database_helper.dart';
// import 'package:todo_app/models/task_model.dart';

// class TaskController extends GetxController {
//   @override
//   void OnReady() {
//     super.onReady();
//   }

//   var taskList = <Task>[].obs;

//   Future<int> addTask({Task? task}) async {
//     return await DBHelper.insert(task);
//   }

//   //get all data from the table
//   void getTasks() async {
//     List<Map<String, dynamic>> tasks = await DBHelper.query();
//     taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
//   }

//   void delete(Task task) {
//     DBHelper.delete(task);
//     getTasks();
//   }

//   void markTaskCompleted(int id) async {
//     await DBHelper.update(id);
//     getTasks();
//   }
// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:todo_app/database/database_helper.dart';
import 'package:todo_app/models/task_model.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task!);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void deleteTask(int id) async {
    await DBHelper.delete(id);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.cancel(id);
    getTasks();
  }

  void markTaskAsCompleted(int id, bool isCompleted) async {
    await DBHelper.updateTask(id, isCompleted);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    if (isCompleted) {
      flutterLocalNotificationsPlugin.cancel(id);
    }
    getTasks();
  }

  Future<void> updateTaskInfo(Task task) async {
    await DBHelper.updateTaskInfo(task);
    getTasks();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    getTasks(); // Fetch all tasks when the controller is ready
  }
}
