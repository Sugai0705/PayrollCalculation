import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'shared/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://hfwvxssdwtyjzwyzenza.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhmd3Z4c3Nkd3R5anp3eXplbnphIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUzNDkzODEsImV4cCI6MjA3MDkyNTM4MX0.Ixd2YxWhhur1J1uFFUn4Cn4og8S8rfy2xUyh3pRyJqU',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: '給与計算アプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // タイトル・アイコン等を黒に
          elevation: 0,
        ),
      ),
    );
  }
}
