import 'package:flutter/material.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  JsonWidgetRegistry? _registry;
  Future<String>_getWidget()async{
    return
       await rootBundle.loadString('assets/login.json');
  }


  @override
  void initState() {
    super.initState();

    _registry = JsonWidgetRegistry.instance;

    // Register values for the text controllers
    _registry!.setValue('emailController', _emailController);
    _registry!.setValue('passwordController', _passwordController);

    // Register functions
    _registry!.registerFunctions({
      'handleLogin': ({args, required registry}) => () {
        // Add your login logic here
        if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
          Navigator.of(context).pushReplacementNamed('/bottom');
        }
      },
      'navigateToSignup': ({args, required registry}) => () {
        // Add signup navigation logic
        print('Navigate to signup');
      },
      'handleForgotPassword': ({args, required registry}) => () {
        // Add forgot password logic
        print('Handle forgot password');
      },

    });

  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getWidget(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          final widgetJson = jsonDecode(snapshot.data!);
          final jsonWidgetData = JsonWidgetData.fromDynamic(
            widgetJson,
            registry: _registry,
          );
          return jsonWidgetData.build(context: context);
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),

            ),
          );
        }
      },
    );
  }
}
