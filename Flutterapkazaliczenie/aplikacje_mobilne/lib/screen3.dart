import 'package:flutter/material.dart';
import 'package:my_app/database.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  void _saveTask() {
    if (_nameController.text.isNotEmpty) {
      Task newTask = Task(
        name: _nameController.text,
        description: _descriptionController.text,
        creationDate: DateTime.now(),
      );

      Navigator.pop(context, newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new task'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Task name',
              placeholder: 'Enter the name of the task...',
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
            ),
            const SizedBox(height: 22),
            _buildTextField(
              controller: _descriptionController,
              label: 'Task description',
              placeholder: 'Enter the task description...',
              onEditingComplete: () => FocusScope.of(context).unfocus(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text('Save task'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    VoidCallback? onEditingComplete,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
      onEditingComplete: onEditingComplete,
    );
  }
}
