import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: "Title"),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: "Description"),
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            minLines: 8,
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(onPressed: submitData, child: Text("Submit"))
        ],
      ),
    );
  }

  void submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final url = "https://api.nstack.in/v1/todos";
    final body = {
      "title": title,
      "description": description,
      "isComplete": false
    };
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {"Content-Type": 'application/json'},
    );

    if (response.statusCode == 201) {
      print(response.statusCode);
      titleController.text = "";
      descriptionController.text = "";
      showSuccessMessage("Creating Succes");
    } else {
      print(response.body);
      showErrorMessage("Creating Fail");
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
