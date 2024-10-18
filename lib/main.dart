import 'package:flutter/material.dart';
import 'package:jadwal_vaksinasi/helpers/user_info.dart';
import 'package:jadwal_vaksinasi/ui/login_page.dart';
import 'package:jadwal_vaksinasi/ui/jadwalvaksinasi_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    var token = await UserInfo().getToken();
    if (token != null) {
      setState(() {
        page = const JadwalVaksinasiPage();
      });
    } else {
      setState(() {
        page = const LoginPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jadwal Vaksinasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Calibri',
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Calibri',
        ),
        primaryTextTheme: ThemeData.light().primaryTextTheme.apply(
          fontFamily: 'Calibri',
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(fontFamily: 'Calibri', fontSize: 20, fontWeight: FontWeight.bold),
        ),
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: page,
    );
  }
}