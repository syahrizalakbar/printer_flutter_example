import 'package:final_project/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkPermission();
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

Future checkPermission() async {
  Map<Permission, PermissionStatus> status = await [
    Permission.storage,
    Permission.mediaLibrary,
  ].request();
}
