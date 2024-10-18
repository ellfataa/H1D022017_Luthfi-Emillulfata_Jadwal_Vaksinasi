import 'package:flutter/material.dart';
import 'package:jadwal_vaksinasi/bloc/login_bloc.dart';
import 'package:jadwal_vaksinasi/helpers/user_info.dart';
import 'package:jadwal_vaksinasi/ui/registrasi_page.dart';
import 'package:jadwal_vaksinasi/ui/jadwalvaksinasi_page.dart';
import 'package:jadwal_vaksinasi/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6EACB),
      appBar: AppBar(
        title: const Text('Aplikasi Manajemen Kesehatan'),
        backgroundColor: Color(0xFFD1E9F6),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login Jadwal Vaksinasi',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _emailTextField(),
                          const SizedBox(height: 20),
                          _passwordTextField(),
                          const SizedBox(height: 30),
                          _buttonLogin(),
                          const SizedBox(height: 30),
                          _menuRegistrasi(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(Icons.email, color: Color(0xFFEECAD5)),
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(Icons.lock, color: Color(0xFFEECAD5)),
      ),
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buttonLogin() {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFD1E9F6),
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        )
            : const Text(
          "Login",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) _submit();
          }
        },
      ),
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    LoginBloc.login(
        email: _emailTextboxController.text,
        password: _passwordTextboxController.text
    ).then((value) async {
      if (value.code == 200) {
        await UserInfo().setToken(value.token.toString());
        await UserInfo().setUserID(int.parse(value.userID.toString()));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login berhasil!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        await Future.delayed(Duration(seconds: 2));

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const JadwalVaksinasiPage()),
        );
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => WarningDialog(
              description: "Login gagal, silahkan coba lagi",
            )
        );
      }
    }, onError: (error) {
      print(error);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => WarningDialog(
            description: "Login gagal, silahkan coba lagi",
          )
      );
    });
    setState(() {
      _isLoading = false;
    });
  }

  Widget _menuRegistrasi() {
    return Center(
      child: SizedBox(
        width: 200,
        child: InkWell(
          child: const Text(
            "Registrasi",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegistrasiPage())
            );
          },
        ),
      ),
    );
  }
}