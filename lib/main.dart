import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:prasta/auth/forgot_password.dart';
import 'package:prasta/auth/login.dart';
import 'package:prasta/auth/register.dart';
import 'package:prasta/views/dashboard_screen.dart';
import 'package:prasta/views/riwayat_screen.dart';
import 'package:prasta/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 4. Inisialisasi data lokalisasi untuk Bahasa Indonesia
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      initialRoute: Day16SplashScreen.id,
      routes: {
        // '/': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        Day16SplashScreen.id: (context) => Day16SplashScreen(),
        LoginPage.id: (context) => const LoginPage(),
        RegisterPage.id: (context) => const RegisterPage(),
        AttendanceHistoryPage.id: (context) => const AttendanceHistoryPage(),
        DashboardScreen.id: (context) => const DashboardScreen(),
        ForgotPasswordScreen.id: (context) => const ForgotPasswordScreen(),
      },
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
