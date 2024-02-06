import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/database.dart';
import 'screen3.dart';

class Screen2 extends StatefulWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen2> {
  List<Task> tasks = [];
  Map<int, bool> completedTasks = {};

  @override
  void initState() {
    super.initState();
    _loadSampleTasks();
  }

  void _loadSampleTasks() {
    setState(() {
      tasks = [
        Task(name: 'Task 1', description: 'Description 1', creationDate: DateTime.now(), isCompleted: false),
        Task(name: 'Task 2', description: 'Description 2', creationDate: DateTime.now(), isCompleted: false),
        Task(name: 'Task 3', description: 'Description 3', creationDate: DateTime.now(), isCompleted: false),
      ];
    });
  }

  void _saveTasks() {
    // Implement task saving logic if necessary
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      _saveTasks();
    });
  }

  void _changeTaskStatus(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      completedTasks[index] = tasks[index].isCompleted;
      _saveTasks();
    });
  }

  void _goToScreen3() async {
    Task? newTask = await Navigator.push<Task?>(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );

    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
        _saveTasks();
      });
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    return dateTime != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(dateTime)
        : 'No date';
  }

  void _showTaskCompletionMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task completed.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome!'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return _buildTaskItem(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToScreen3,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskItem(int index) {
    return Container(
      color: Colors.orange[50],
      child: ListTile(
        title: Row(
          children: [
            Checkbox(
              value: tasks[index].isCompleted,
              onChanged: (value) {
                _changeTaskStatus(index);
                if (value == true) {
                  _showTaskCompletionMessage();
                }
              },
            ),
            Text(tasks[index].name),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Creation date: ${_formatDateTime(tasks[index].creationDate)}'),
            Text('Description: ${tasks[index].description}'),
            if (completedTasks[index] == true)
              const Text(
                'Finished.',
                style: TextStyle(
                  color: Color.fromARGB(255, 60, 199, 65),
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            _deleteTask(index);
          },
          icon: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
