import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_entry_screen.dart';
import 'screens/entry_detail_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Journal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/addEntry': (context) => AddEntryScreen(),
        '/entryDetail': (context) => EntryDetailScreen(),
      },
    );
  }
}
