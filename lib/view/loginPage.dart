import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skripsiii/constants/route.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/helper/location.dart';
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
  final MemberController memberController = Get.find<MemberController>();
  final ShopController shopController = Get.find<ShopController>();

  String? _email;
  String? _password;

  Future<String?> submitCommand() async {
    var userCred = await loginController.signInWithEmailPassword(
        email: _email!, password: _password!);
    if (userCred != null) {
      Map<String, dynamic> map = {
        "email": _email,
        'password': _password,
        'userid': userCred.user!.uid,
      };
      var x = await loginController.manualLogin(map);
      if (x.runtimeType == Member) {
        // var m = await loginController.getMemberData(x.memberID);
        var location = await LocationHelper.instance.getCurrentLocation();
        x.latitude = location.latitude;
        x.longitude = location.longitude;
        memberController.member.value = x;
        print('memberController.member.value : ${memberController.member.value}');
        return 'member';
      } else if (x.runtimeType == Shop) {
        shopController.shop.value = x;
        return 'shop';
      }
      // TODO user is not finished to fill all required data
      else if (x == null) {
        return null;
      }
    }
    return 'error';
  }

  Future<String?> googleLogin() async {
    var x = await loginController.googleLogin();
    if (x.runtimeType == Member) {
      var location = await LocationHelper.instance.getCurrentLocation();
      x.latitude = location.latitude;
      x.longitude = location.longitude;
      memberController.member.value = x;
      return 'member';
    } else if (x.runtimeType == Shop) {
      shopController.shop.value = x;
      return 'shop';
    } else if (x == null) {
      return null;
    }
    // TODO user is not finished to fill all required data
    else {
      return 'error';
    }
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
                                  var a = await submitCommand();
                                  if (mounted) {
                                    if (a == 'shop') {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                        botNavRouteShop,
                                        (route) => false,
                                      );
                                    } else if (a == 'member') {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                        botNavRouteMember,
                                        (route) => false,
                                      );
                                    } else if (a == null) {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                        registerRoute,
                                        (route) => false,
                                      );
                                    } else {
                                      // TODO show error since user not found
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
                            if (u == 'member') {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                botNavRouteMember,
                                (route) => false,
                              );
                            } else if (u == 'shop') {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                botNavRouteShop,
                                (route) => false,
                              );
                            } else if (u == null) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                registerRoute,
                                (route) => false,
                              );
                            } else {
                              // TODO have to complete filling data first (role)
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

// import 'package:flutter/material.dart';

/// Flutter code sample for [PageStorage].

void main() => runApp(const PageStorageExampleApp());

class PageStorageExampleApp extends StatelessWidget {
  const PageStorageExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> pages = const <Widget>[
    ColorBoxPage(
      key: PageStorageKey<String>('pageOne'),
    ),
    ColorBoxPage(
      key: PageStorageKey<String>('pageTwo'),
    ),
  ];
  int currentTab = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistence Example'),
      ),
      body: PageStorage(
        bucket: _bucket,
        child: pages[currentTab],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'page 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'page2',
          ),
        ],
      ),
    );
  }
}

class ColorBoxPage extends StatelessWidget {
  const ColorBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: 250.0,
      itemBuilder: (BuildContext context, int index) => Container(
        padding: const EdgeInsets.all(10.0),
        child: Material(
          color: index.isEven ? Colors.cyan : Colors.deepOrange,
          child: Center(
            child: Text(index.toString()),
          ),
        ),
      ),
    );
  }
}
