
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skripsiii/constants/route.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/helper/location.dart';
import 'package:skripsiii/model/memberModel.dart';
import 'package:skripsiii/model/shopModel.dart';
import 'package:skripsiii/view/forgotPasswordPage.dart';
import 'package:skripsiii/widget/button36x220.dart';
import 'package:skripsiii/controller/loginController.dart';
import 'package:get/get.dart';

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
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color.fromRGBO(56, 56, 56, 1),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        body: Center(
          child: Obx(
            () {
              if (pageVM.isLoading.value) {
                return LoadingAnimationWidget.threeArchedCircle(
                  color: Colors.lightBlue,
                  size: 50,
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
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
                                    validator: (value) =>
                                        EmailValidator.validate(value!)
                                            ? null
                                            : 'Invalid Email',
                                    onSaved: (newValue) => _email = newValue,
                                    onTapOutside: (_) =>
                                        FocusScope.of(context).unfocus(),
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
                                    onTapOutside: (_) =>
                                        FocusScope.of(context).unfocus(),
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
                              if (mounted) {
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              }
                            }
                          }
                          pageVM.doneLoading();
                        },
                        icon: Image.asset(
                          'data/images/googleIcon.png',
                          width: 25,
                          height: 25,
                        ),
                        label: const Text(
                          'Sign in with Google',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ForgotPaswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
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
