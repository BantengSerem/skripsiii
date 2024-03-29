import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/controller/loginController.dart';
import 'package:skripsiii/transition/slideFadeTransition.dart';
import 'package:skripsiii/view/registerInfoMemberPage.dart';
import 'package:skripsiii/view/registerInfoShopPage.dart';
import 'dart:developer' as devtools show log;

import 'package:skripsiii/widget/button36x220.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  // final String? email;
  // final String? password;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.find<LoginController>();

  final List<String> option = ['Member', 'Shop'];
  String? dropDownValue;
  String? role;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // String? dropDownValue;

  // setOption() {
  //   dropDownValue = option.first;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: Center(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'What are you registering as?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 44,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      DropdownButtonFormField(
                        decoration:
                            const InputDecoration(hintText: 'Select Role'),
                        value: dropDownValue,
                        icon: const Icon(Icons.expand_more),
                        elevation: 16,
                        items: option
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropDownValue = value!;
                          });
                          devtools.log(value.toString());
                        },
                        onSaved: (newValue) => role = newValue,
                        validator: (value) =>
                            value != null ? null : 'Please select a role',
                      ),
                      const SizedBox(
                        height: 200,
                      ),
                      Button36x220(
                        text: 'Continue',
                        func: () {
                          final form = _formKey.currentState;

                          if (form!.validate()) {
                            form.save();

                            if (role == 'Member') {
                              Navigator.of(context).push(
                                SlideFadeTransition(
                                  child: const RegisterInfoMemberPage(),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                SlideFadeTransition(
                                  child: const RegisterInfoShopPage(),
                                ),
                              );
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
