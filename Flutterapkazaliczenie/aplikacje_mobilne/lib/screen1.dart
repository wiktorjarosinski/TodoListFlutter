import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen2.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final TextEditingController _nameController = TextEditingController();
  bool _isNameValid = true;

  @override
  void initState() {
    super.initState();
    _checkIfNameExists();
  }

  _checkIfNameExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedName = prefs.getString('userName') ?? '';

    if (savedName.isNotEmpty) {
      setState(() {
        _nameController.text = savedName;
      });
    }
  }

  _saveName() async {
    String enteredName = _nameController.text.trim();

    if (enteredName.length >= 3) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', enteredName);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Screen2()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Enter your name',
                errorText: _isNameValid ? null : 'Name must be at least 3 characters long',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveName,
              child: const Text('Save Name'),
            ),
          ],
        ),
      ),
    );
  }
}
