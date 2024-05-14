import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'main.dart';

class Task {
  String? id;
  String title = '';
  DateTime dueDate = DateTime.now();
  bool completed = false;
  String? description = '';
  Task({
    required this.title,
    required this.dueDate,
  });
}

class TaskList extends StatefulWidget {
  const TaskList({
    super.key,
  });

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks = [];

  Future<void> fetch() async {
    try {
      await Parse().initialize(applicationId, parseURL,
          clientKey: clientKey, autoSendSessionId: true);
      var user = await ParseUser.currentUser();
      final queryBuilder = QueryBuilder(ParseObject('Tasks'))
        ..whereEqualTo('user', user.username);
      final response = await queryBuilder.query();
      List<Task> results = [];
      if (response.success && response.results != null) {
        for (var o in response.results!) {
          Task task = Task(title: o['title'], dueDate: o['dueDate']);
          task.id = o['objectId'];
          task.description = o['description'];
          task.completed = o['completed'];
          results.add(task);
        }
      }
      setState(() {
        tasks = results;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> delete(String id) async {
    try {
      await Parse().initialize(applicationId, parseURL,
          clientKey: clientKey, autoSendSessionId: true);

      final parseObject = ParseObject('Tasks')..set<String>('objectId', id);
      final response = await parseObject.delete();
      return response.success;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Buddy',
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: InkWell(
              onTap: () async {
                await Navigator.of(context).pushNamed(
                  '/view-details',
                  arguments: {'task': task},
                );
                await fetch();
              },
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                leading: const Icon(Icons.alarm),
                title: Text(task.title),
                subtitle: Text(task.description ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    bool success = await delete(task.id!);
                    if (success) {
                      await fetch();
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(
            '/view-details',
            arguments: {'task': Task(title: '', dueDate: DateTime.now())},
          );
          await fetch();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
