import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:latihan_flutter/services/task_service.dart';
import 'package:latihan_flutter/ui/add_task_ui.dart';

import '../models/task_model.dart';

class MyTaskUi extends StatefulWidget {
  const MyTaskUi({super.key});

  @override
  State<MyTaskUi> createState() => _MyTaskUiState();
}

class _MyTaskUiState extends State<MyTaskUi> {
  List<TaskModel> tasks = [];

  Future<void> getTasks() async {
    tasks = await TaskService().getTask();
    setState(() {});
  }

  Future<void> updateStatusTask(
      {required String id, required bool value}) async {
    EasyLoading.show(status: "Loading");
    bool result = await TaskService().updateStatusTask(id: id, value: value);

    if (result) {
      getTasks();
      EasyLoading.dismiss();
    }
  }

  Future<void> deleteTask({required String id}) async {
    EasyLoading.show(status: "Loading");
    bool result = await TaskService().deleteTask(id: id);

    if (result) {
      await getTasks();
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Task",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          await Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddTaskUI()));
          getTasks();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Column(
            children: List.generate(
              tasks.length,
              (index) {
                TaskModel task = tasks[index];
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 15)
                      .copyWith(bottom: 15),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: task.status,
                        onChanged: (value) {
                          if (value != null) {
                            updateStatusTask(id: task.id, value: value);
                          }
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.todo,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              task.description,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteTask(id: task.id);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
