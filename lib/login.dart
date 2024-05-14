import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/helpers/app_regex.dart';
import 'package:flutter_demo/helpers/helper_service.dart';
import 'package:flutter_demo/themes/styles.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class User {
  String username;
  String email;
  String password;

  User({required this.username, required this.email, required this.password});
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController =
      TextEditingController(text: '');
  final TextEditingController _passwordController =
      TextEditingController(text: '');
  final TextEditingController _rePasswordController =
      TextEditingController(text: '');
  final TextEditingController _emailController =
      TextEditingController(text: '');
  bool login1 = true;
  HelperService helperService = HelperService();

  //login
  Future<bool> login(String username, String password) async {
    try {
      await Parse().initialize(applicationId, parseURL,
          clientKey: clientKey, autoSendSessionId: true);

      final parseUser = ParseUser(username, password, null);
      final result = await parseUser.login();
      return result.success;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //logout
  Future<bool> logout() async {
    try {
      final ParseUser parseUser = await ParseUser.currentUser();
      final result = await parseUser.logout();
      return result.success;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //signup
  Future<bool> signup(User user) async {
    try {
      await Parse().initialize(applicationId, parseURL,
          clientKey: clientKey, autoSendSessionId: true);

      final parseUser = ParseUser(user.username, user.password, user.email);
      final result = await parseUser.signUp();
      return result.success;
    } catch (e) {
      // Handle error
      print(e);
      return false;
    }
  }

  List<Widget> signupForm() {
    const double height = 60;
    const EdgeInsets padding = EdgeInsets.fromLTRB(50, 0, 50, 0);
    return [
      Container(
          height: 60,
          padding: padding,
          alignment: Alignment.center,
          child: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 30.0,
            // flexibleSpace: Container(),
            centerTitle: true,
            elevation: 10,
            shape: const Border(
              bottom: BorderSide(width: 1, color: Colors.black12),
            ),
            title: const Text('QuickTask',
                overflow: TextOverflow.clip,
                softWrap: false,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                )),
            backgroundColor: Colors.lightBlue,
          )),
      Container(
        height: height,
        padding: padding,
        alignment: Alignment.center,
        child: TextFormField(
          controller: _usernameController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Enter Username',
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
          ),
        ),
      ),
      Container(
        height: height,
        padding: padding,
        alignment: Alignment.center,
        child: TextFormField(
          obscureText: true,
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
            labelText: 'Enter Password',
            suffixIcon: Icon(Icons.visibility_off),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
          ),
        ),
      ),
      Container(
        height: height,
        padding: padding,
        alignment: Alignment.center,
        child: TextFormField(
          obscureText: true,
          controller: _rePasswordController,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
            labelText: 'Enter Password Again',
            suffixIcon: Icon(Icons.visibility_off),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
          ),
        ),
      ),
      Container(
        height: height,
        padding: padding,
        alignment: Alignment.center,
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Enter Email',
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
        child: ElevatedButton(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(const Size(200, 50)),
          ),
          onPressed: () async {
            String username = _usernameController.text.trim().toLowerCase();
            String password = _passwordController.text;
            String rePassword = _rePasswordController.text;
            String email = _emailController.text.trim().toLowerCase();
            if (password != rePassword) {
              helperService.showMessage(
                  context, 'Password and Re-password do not match.',
                  error: true);
              return;
            }
            if (!AppRegexHelper.isEmailValid(email)) {
              helperService.showMessage(context, 'Please provide valid email.',
                  error: true);
              return;
            }
            if (!AppRegexHelper.hasMinLength(password) ||
                !AppRegexHelper.hasMinLength(rePassword)) {
              helperService.showMessage(
                  context, 'Please provide at least 6 characters in password.',
                  error: true);
              return;
            }

            User user =
                User(username: username, email: email, password: password);
            signup(user).then((success) {
              if (success) {
                _passwordController.clear();
                _rePasswordController.clear();
                _emailController.clear();
                setState(() {
                  login1 = true;
                });
                helperService.showMessage(
                    context, 'Signup successful, please login.');
              } else {
                helperService.showMessage(context,
                    'Username or email already exists, please try again.',
                    error: true);
              }
            });
            await AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.rightSlide,
              title: 'Sign up Success',
              desc: 'You have successfully signed up.',
            ).show();
          },
          child:
              const Text('Signup', style: TextStyles.font11DarkBlue400Weight),
        ),
      ),
      TextButton(
        onPressed: () {
          setState(() {
            login1 = true;
          });
        },
        child: const Text('Already have an account?',
            style: TextStyles.font11DarkBlue400Weight),
      ),
    ];
  }

  List<Widget> loginForm() {
    const double height = 100;
    const EdgeInsets padding = EdgeInsets.fromLTRB(80, 0, 80, 0);
    return [
      Container(
          height: 60,
          padding: padding,
          alignment: Alignment.center,
          child: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 30.0,
            // flexibleSpace: Container(),
            centerTitle: true,
            elevation: 10,
            shape: const Border(
              bottom: BorderSide(width: 1, color: Colors.black12),
            ),
            title: const Text('QuickTask',
                overflow: TextOverflow.clip,
                softWrap: false,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                )),
            backgroundColor: Colors.lightBlue,
          )),
      Container(
        height: height,
        padding: padding,
        alignment: Alignment.center,
        child: TextFormField(
          controller: _usernameController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Enter Username',
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
          ),
        ),
      ),
      Container(
        height: height,
        padding: padding,
        alignment: Alignment.center,
        child: TextFormField(
          obscureText: true,
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
            labelText: 'Enter Password',
            suffixIcon: Icon(Icons.visibility_off),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
        child: ElevatedButton(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(const Size(200, 50)),
          ),
          onPressed: () async {
            String username = _usernameController.text.trim().toLowerCase();
            String password = _passwordController.text;

            login(username, password).then((success) {
              if (success) {
                // helperService.showMessage(context, 'Login Successful.');
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.success,
                  animType: AnimType.rightSlide,
                  title: 'Login Success',
                  desc: 'You have successfully Logged up.',
                ).show();
                Navigator.of(context).pushReplacementNamed("/");
              } else {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'Error',
                  desc: 'Wrong username or password provided.',
                ).show();
              }
            });
          },
          child: const Text('Login', style: TextStyles.font11DarkBlue400Weight),
        ),
      ),
      TextButton(
        onPressed: () {
          setState(() {
            login1 = false;
          });
        },
        child: const Text('Signup?', style: TextStyles.font11DarkBlue400Weight),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            ...login1 ? loginForm() : signupForm(),
          ],
        ),
      ),
    );
  }
}