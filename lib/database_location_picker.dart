// ignore: unused_import
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'database_helper.dart'; // Import DatabaseHelper
import 'login_page.dart'; // Import LoginPage (placeholder)

class DatabaseLocationPicker extends StatefulWidget {
  const DatabaseLocationPicker({super.key});

  @override
  DatabaseLocationPickerState createState() => DatabaseLocationPickerState();
}

class DatabaseLocationPickerState extends State<DatabaseLocationPicker> {
  String? _selectedPath;

  Future<void> _pickDatabaseLocation() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Database Option'),
        content: const Text(
            'Would you like to use an existing database or create a new one?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _pickExistingDatabase();
            },
            child: const Text('Use Existing Database'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _createNewDatabase();
            },
            child: const Text('Create New Database'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickExistingDatabase() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select an existing database file',
      type: FileType.custom,
      allowedExtensions: ['db'],
    );
    if (result != null && result.files.isNotEmpty) {
      String selectedFilePath = result.files.single.path!;
      if (selectedFilePath.endsWith('denr_cenroquezon.db')) {
        setState(() {
          _selectedPath = selectedFilePath;
        });
        DatabaseHelper.instance.setCustomDatabasePath(selectedFilePath);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Please select a file named "denr_cenroquezon.db"')),
        );
      }
    }
  }

  Future<void> _createNewDatabase() async {
    String? result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select a folder to store the new database',
    );
    if (result != null) {
      String dbPath = join(result, 'denr_cenroquezon.db');
      setState(() {
        _selectedPath = dbPath;
      });
      DatabaseHelper.instance.setCustomDatabasePath(dbPath);
      await DatabaseHelper.instance.addDefaultAdmin();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 46, 46, 48),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Select Database Location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose an existing database file or a folder to create a new database.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickDatabaseLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 13, 136, 69),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.white, width: 0.7),
                  ),
                ),
                child: const Text(
                  'Browse',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_selectedPath != null)
                Text(
                  'Selected: $_selectedPath',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
