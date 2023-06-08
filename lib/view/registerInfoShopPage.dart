import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:developer' as devtools show log;

class RegisterInfoShopPage extends StatefulWidget {
  const RegisterInfoShopPage({super.key});

  @override
  State<RegisterInfoShopPage> createState() => _RegisterInfoShopPageState();
}

class _RegisterInfoShopPageState extends State<RegisterInfoShopPage> {
  final _formKey = GlobalKey<FormState>();
  final String role = 'shop';

  String? _email;
  String? _password;
  String? _shopName;
  String? _phone;
  String? _address;
  String? _city;
  String? _province;
  String? _country;
  String? _postalCode;

  var _activeStepIndex = 0;

  submitCommand() {
    var form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      Map<String, dynamic> data = {
        'email': _email,
        'password': _password,
        'shopName': _shopName,
        'phone': _phone,
        'address': _address,
        'city': _city,
        'province': _province,
        'country': _country,
        'postalCode': _postalCode
      };
      devtools.log(data.toString());
    }
    devtools.log('Submitted');
  }

  List<Step> stepListMember() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          title: const Text('Credentials'),
          content: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: 'Email'),
                onSaved: (newValue) => _email = newValue,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Password'),
                onSaved: (newValue) => _password = newValue,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Step(
          state: _activeStepIndex == 1
              ? StepState.editing
              : _activeStepIndex > 1
                  ? StepState.complete
                  : StepState.indexed,
          title: const Text('Info'),
          content: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: 'Shop Name'),
                onSaved: (newValue) => _shopName = newValue,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(hintText: 'Phone'),
                onSaved: (newValue) => _phone = newValue,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Step(
          state: _activeStepIndex == 2
              ? StepState.editing
              : _activeStepIndex > 2
                  ? StepState.complete
                  : StepState.indexed,
          title: const Text('Address'),
          content: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: 'Address'),
                onSaved: (newValue) => _address = newValue,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    child: TextFormField(
                      decoration: const InputDecoration(hintText: 'City'),
                      onSaved: (newValue) => _city = newValue,
                    ),
                  ),
                  const SizedBox(
                    width: 28,
                  ),
                  SizedBox(
                    width: 140,
                    child: TextFormField(
                      decoration: const InputDecoration(hintText: 'Province'),
                      onSaved: (newValue) => _province = newValue,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    child: TextFormField(
                      decoration: const InputDecoration(hintText: 'Country'),
                      onSaved: (newValue) => _country = newValue,
                    ),
                  ),
                  const SizedBox(
                    width: 28,
                  ),
                  SizedBox(
                    width: 140,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration:
                          const InputDecoration(hintText: 'Postal Code'),
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter postal code';
                        }
                        return null;
                      },
                      onSaved: (newValue) => _postalCode = newValue,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        )
      ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              'Register',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Stepper(
              steps: stepListMember(),
              type: StepperType.vertical,
              currentStep: _activeStepIndex,
              onStepContinue: () {
                if (_activeStepIndex < (stepListMember().length - 1)) {
                  setState(() {
                    _activeStepIndex += 1;
                  });
                } else {
                  submitCommand();
                }
              },
              onStepCancel: () {
                if (_activeStepIndex == 0) {
                  return;
                }

                setState(() {
                  _activeStepIndex -= 1;
                });
              },
              onStepTapped: (int index) {
                setState(
                  () {
                    _activeStepIndex = index;
                  },
                );
              },
              controlsBuilder: (context, details) {
                final isLastStep =
                    _activeStepIndex == stepListMember().length - 1;
                return Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: (isLastStep)
                            ? const Text('Submit')
                            : const Text('Next'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (_activeStepIndex > 0)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Back'),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
