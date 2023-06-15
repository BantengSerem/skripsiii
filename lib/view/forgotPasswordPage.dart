import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skripsiii/controller/loginController.dart';

class ForgotPaswordPage extends StatefulWidget {
  const ForgotPaswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPaswordPage> createState() => _ForgotPaswordPageState();
}

class _ForgotPaswordPageState extends State<ForgotPaswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final LoginController loginController = Get.find<LoginController>();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }

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
                Navigator.pop(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Center(
        child: Material(
          elevation: 5,
          child: Container(
            width: 250,
            height: 300,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Recieve an email to reset your password',
                    style: TextStyle(
                      fontSize: 19,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      controller: emailController,
                      decoration: const InputDecoration(
                        label: Text('Email'),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Enter a valid email'
                              : null,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Center(
                                child: LoadingAnimationWidget.threeArchedCircle(
                                  color: Colors.lightBlue,
                                  size: 50,
                                ),
                              ));
                      try {
                        await loginController
                            .verifyEmail(emailController.text.trim());
                        if (mounted) {
                          // Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text('Password Reset Email Sent')));
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        }
                      } catch (e) {
                        if (mounted) {
                          // Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text(e.toString())));
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        }
                      }
                    },
                    icon: const Icon(Icons.email_outlined),
                    label: const Text(
                      'Reset Password',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
