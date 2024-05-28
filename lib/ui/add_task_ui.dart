import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:latihan_flutter/services/task_service.dart';

class AddTaskUI extends StatefulWidget {
  const AddTaskUI({super.key});

  @override
  State<AddTaskUI> createState() => _AddTaskUIState();
}

class _AddTaskUIState extends State<AddTaskUI> {
  TextEditingController titleC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();
  Future<void> addTask() async {
    if (titleC.text == "" && descriptionC.text == "") {
      EasyLoading.showToast("Please input title and description");
    } else {
      EasyLoading.show(status: "Loading...");
      final result = await TaskService().addTask(
        title: titleC.text,
        description: descriptionC.text,
      );
      EasyLoading.dismiss();
      if (result) {
        Navigator.pop(context);
      } else {
        EasyLoading.showToast("Failed add data");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "Add Task",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: ElevatedButton(
            onPressed: () {
              addTask();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
            child: Text("Save")),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: titleC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  isDense: true,
                  labelText: "Title",
                  hintText: "Enter Title"),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: descriptionC,
              maxLines: 10,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  isDense: true,
                  labelText: "Description",
                  hintText: "Enter Description"),
            ),
          )
        ],
      ),
    );
  }
}
