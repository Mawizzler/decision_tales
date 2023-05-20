import 'package:flutter/material.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: "https://gvtezygxdrurgafavvxx.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd2dGV6eWd4ZHJ1cmdhZmF2dnh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODQwNjY3NTQsImV4cCI6MTk5OTY0Mjc1NH0.lJj_vaCCWOX6OL0VqeXXwgn32kfoQ8SoHioEmCc2JtY",
      authCallbackUrlHostname: 'login-callback', // optional
      debug: false // optional
      );
  runApp(const MyApp());
}

final client = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Decision Stories',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const MyHomePage(),
      },
    );
  }
}
