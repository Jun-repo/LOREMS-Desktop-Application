import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:flutter/foundation.dart' as Foundation;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' show join, normalize;
import 'dart:ui' as ui; // Import dart:ui with alias
import 'dart:ffi' as ffi; // Import dart:ffi with alias
import 'database_location_picker.dart'; // Import the picker

String findPackagePath(String currentPath) {
  return currentPath;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite for desktop
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  if (Foundation.defaultTargetPlatform == TargetPlatform.windows) {
    windowsInit();
  }

  runApp(MyAppInitializer());

  doWhenWindowReady(() {
    const initialSize = ui.Size(1200, 660); // Use ui.Size
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = "Database Location - GIC Records";
    appWindow.show();
  });
}

void windowsInit() {
  String path = "";
  if (Foundation.kDebugMode) {
    String location = findPackagePath(Directory.current.path);
    path = normalize(join(location, 'lib', 'src', 'windows', 'sqlite3.dll'));
  } else {
    path = "sqlite3.dll";
  }

  open.overrideFor(OperatingSystem.windows, () {
    try {
      return ffi.DynamicLibrary.open(path); // Use ffi.DynamicLibrary
    } catch (e) {
      stderr.writeln('Failed to load sqlite3.dll at $path');
      rethrow;
    }
  });

  sqlite3.openInMemory().dispose();
}

class MyAppInitializer extends StatelessWidget {
  MyAppInitializer({super.key});

  final Future<void> _initialization =
      Future.delayed(const Duration(seconds: 1));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: DatabaseLocationPicker(), // Start with the picker
          );
        }
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Color.fromARGB(250, 46, 46, 48),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
