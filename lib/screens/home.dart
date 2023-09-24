import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restapi_crud/screens/add_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List items = [];
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    fetchTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Todo list"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: Text("Add todo")),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
              shrinkWrap: false,
              itemCount: items.length,
              itemBuilder: (contex, index) {
                final item = items[index];
                final id = item['_id'] as String;
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(item["title"]),
                  subtitle: Text(item["description"]),
                  trailing: PopupMenuButton(onSelected: (value) {
                    if (value == 'edit') {
                    } else if (value == 'delete') {
                      deleteById(id);
                    }
                  }, itemBuilder: (contex) {
                    return [
                      PopupMenuItem(
                        child: Text("Edit"),
                        value: 'edit',
                      ),
                      PopupMenuItem(
                        child: Text("Delete"),
                        value: 'delete',
                      )
                    ];
                  }),
                );
              }),
        ),
      ),
    );
  }

  void navigateToAddPage() {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    Navigator.push(context, route);
  }

  Future<void> fetchTodo() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json["items"] as List;
      setState(() {
        items = result;
      });
    } else {}
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }
  }
}
