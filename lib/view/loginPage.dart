import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skripsiii/constants/route.dart';
import 'package:skripsiii/widget/button36x220.dart';
import 'package:skripsiii/controller/loginController.dart';
import 'package:get/get.dart';
import 'dart:developer' as devtools show log;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.find<LoginController>();

  String? _email;
  String? _password;

  void submitCommand() async {
    final form = _formKey.currentState;

    FocusManager.instance.primaryFocus?.unfocus();
    if (form!.validate()) {
      form.save();
      Map<String, dynamic> map = {
        "email": _email,
        'password': _password,
      };

      await loginController.signInWithEmailPassword(
          email: _email!, password: _password!);
      var x = await loginController.manualLogin(map);

      devtools.log(x.toString());

      Navigator.of(context)
          .pushNamedAndRemoveUntil(homeRoute, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Login',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 44,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter Email',
                      ),
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => EmailValidator.validate(value!)
                          ? null
                          : 'Invalid Email',
                      onSaved: (newValue) => _email = newValue,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter Password',
                      ),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 4) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                      onSaved: (newValue) => _password = newValue,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Button36x220(
                text: 'Login',
                func: submitCommand,
              )
            ],
          ),
        ),
      ),
    );
  }
}
