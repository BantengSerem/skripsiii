import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skripsiii/constants/route.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/model/memberModel.dart';
import 'package:skripsiii/model/shopModel.dart';
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
  final LoginPageVM pageVM = Get.put<LoginPageVM>(LoginPageVM());

  String? _email;
  String? _password;

  Future<bool> submitCommand() async {
    Map<String, dynamic> map = {
      "email": _email,
      'password': _password,
    };
    var userCred = await loginController.signInWithEmailPassword(
        email: _email!, password: _password!);
    if (userCred != null) {
      var x = await loginController.manualLogin(map);
      if (x.runtimeType == Member) {
        MemberController().member = x;
      } else if (x.runtimeType == Shop) {
        ShopController().shop = x;
      }
      // TODO user is not finished to fill all required data
      else {
        return false;
      }

      // print(x.toString());
      return true;
    }
    return false;
  }

  Future<bool> googleLogin() async {
    var x = await loginController.googleLogin();
    if (x.runtimeType == Member) {
      MemberController().member = x;
    } else if (x.runtimeType == Shop) {
      ShopController().shop = x;
    }
    // TODO user is not finished to fill all required data
    else {
      return false;
    }

    return true;
  }

  Future<bool?> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
      barrierDismissible: true,
    );
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return const AlertDialog(
      title: Center(child: Text('Sorry User Not Found')),
      content: Text('Please check your email and password'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Center(
            child: Obx(
              () {
                if (pageVM.isLoading.value) {
                  return LoadingAnimationWidget.threeArchedCircle(
                    color: Colors.lightBlue,
                    size: 50,
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Email',
                                    ),
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) =>
                                        EmailValidator.validate(value!)
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
                              func: () async {
                                pageVM.loading();
                                final form = _formKey.currentState;

                                if (form!.validate()) {
                                  form.save();
                                  bool a = await submitCommand();
                                  if (mounted) {
                                    if (a) {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                        homeRoute,
                                        (route) => false,
                                      );
                                    } else {
                                      await _showExitDialog(context);
                                    }
                                  }
                                }
                                pageVM.doneLoading();
                              },
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text('continue with google'),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                        style: const ButtonStyle(
                          shadowColor:
                              MaterialStatePropertyAll<Color>(Colors.black),
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.white),
                        ),
                        onPressed: () async {
                          pageVM.loading();
                          var u = await googleLogin();
                          if (mounted) {
                            if (u) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                homeRoute,
                                (route) => false,
                              );
                            } else {
                              await _showExitDialog(context);
                            }
                          }
                          pageVM.doneLoading();
                        },
                        icon: const Icon(Icons.abc_rounded),
                        label: const Text(
                          'Sign in with Google',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPageVM extends GetxController {
  RxBool isLoading = false.obs;

  void loading() {
    isLoading.value = true;
  }

  void doneLoading() {
    isLoading.value = false;
  }
}
