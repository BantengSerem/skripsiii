import 'dart:ffi';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:skripsiii/constants/indonesiaRepo.dart';
import 'package:skripsiii/constants/listProvinces.dart';
import 'package:skripsiii/constants/route.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/model/addressModel.dart';
import 'dart:developer' as devtools show log;
import 'package:uuid/uuid.dart';
import 'package:skripsiii/controller/registerController.dart';
import 'package:skripsiii/model/memberModel.dart';

class RegisterInfoMemberPage extends StatefulWidget {
  const RegisterInfoMemberPage({super.key});

  @override
  State<RegisterInfoMemberPage> createState() => _RegisterInfoMemberPageState();
}

class _RegisterInfoMemberPageState extends State<RegisterInfoMemberPage> {
  final _formKey = GlobalKey<FormState>();
  final String role = 'member';
  final RegisterController registerController = Get.find<RegisterController>();
  final MemberController memberController = Get.find<MemberController>();
  final IndoRepo repo = IndoRepo();

  String? _email;
  String? _password;
  String? _name;
  String? _username;
  String? _phone;
  String? _address;
  String? _city;
  String? _province;
  String? _postalCode;

  var _activeStepIndex = 0;
  String? _dropDownProvinceValue;
  String? _dropDownCityValue;
  List<String?> provinces = [];
  List<dynamic> cities = [];

  Future<bool> submitCommand() async {
    var form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      var uuid = const Uuid();
      String _memberId = uuid.v4();
      String _addressId = uuid.v4();

      // Map<String, dynamic> data = {
      //   'email': _email,
      //   'password': _password,
      //   'name': _name,
      //   'username': _username,
      //   'phone': _phone,
      //   'address': _address,
      //   'city': _city,
      //   'province': _province,
      //   'postalCode': _postalCode
      // };
      // devtools.log(data.toString());
      Member m = Member(
        email: _email!,
        password: _password!,
        memberID: _memberId,
        username: _username!,
        name: _name!,
        contacts: _phone!,
      );

      Address x = Address(
        addressId: _addressId,
        memberId: _memberId,
        address: _address!,
        province: _province!,
        city: _city!,
        poscode: _postalCode!,
      );

      var userCred =
          await registerController.registerMember(_email!, _password!);
      if (userCred != null) {
        Member m = Member(
          email: _email!,
          password: _password!,
          memberID: userCred.user!.uid.toString(),
          username: _username!,
          name: _name!,
          contacts: _phone!,
        );
        bool a = await registerController.addMemberToFirebase(m);
        await registerController.addAddressToFirebase(x);
        if (a) {
          memberController.member.value = m;
          print(
              'memberController.member.value : ${memberController.member.value}');
        }
        devtools.log('Submitted');
        return a;
      }
    }
    return false;
  }

  List<Step> stepListMember() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          title: const Text('Credentials'),
          content: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: 'Email'),
                validator: (value) =>
                    EmailValidator.validate(value!) ? null : 'Invalid Email',
                onSaved: (newValue) => _email = newValue,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 4) {
                    return 'Please enter password';
                  }
                  return null;
                },
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
                decoration: const InputDecoration(hintText: 'Name'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter name'
                    : null,
                onSaved: (newValue) => _name = newValue,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Username'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter username'
                    : null,
                onSaved: (newValue) => _username = newValue,
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
                validator: (value) =>
                    (value == null || value.isEmpty || value.length < 10)
                        ? 'Please enter phone number'
                        : null,
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
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter address'
                    : null,
                onSaved: (newValue) => _address = newValue,
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(hintText: 'Province'),
                value: _dropDownProvinceValue,
                elevation: 16,
                menuMaxHeight: 300,
                icon: const Icon(Icons.expand_more),
                items: provinces.map<DropdownMenuItem<String>>(
                  (String? provinceValue) {
                    return DropdownMenuItem(
                      value: provinceValue,
                      child: Text(provinceValue!),
                    );
                  },
                ).toList(),
                onChanged: (String? provinceValue) {
                  setState(() {
                    cities = [];
                    _dropDownCityValue = null;
                    _dropDownProvinceValue = provinceValue!;
                    // devtools.log(provinceValue);
                    cities = repo.getCityByProvince(provinceValue);
                    // devtools.log(cities.toString());
                  });
                },
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please select province'
                    : null,
                onSaved: (newValue) => _province = newValue,
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(hintText: 'City'),
                value: _dropDownCityValue,
                elevation: 16,
                menuMaxHeight: 300,
                icon: const Icon(Icons.expand_more),
                items: cities.map<DropdownMenuItem<String>>(
                  (dynamic cityValue) {
                    return DropdownMenuItem(
                      value: cityValue,
                      child: Text(cityValue!),
                    );
                  },
                ).toList(),
                onChanged: (String? cityValue) {
                  setState(() {
                    _dropDownCityValue = cityValue!;
                  });
                },
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please select city'
                    : null,
                onSaved: (newValue) => _city = newValue,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(hintText: 'Postal Code'),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 5) {
                    return 'Please enter postal code';
                  }
                  return null;
                },
                onSaved: (newValue) => _postalCode = newValue,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        )
      ];

  @override
  void initState() {
    provinces = repo.getProvinces();
    // devtools.log(provinces.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text(
            'Register',
            style: TextStyle(color: Colors.black),
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
              onStepContinue: () async {
                if (_activeStepIndex < (stepListMember().length - 1)) {
                  setState(() {
                    _activeStepIndex += 1;
                  });
                } else {
                  var a = await submitCommand();
                  if (a) {
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        botNavRoute,
                        (route) => false,
                      );
                    }
                  }
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
                if (index - _activeStepIndex <= 1) {
                  setState(
                    () {
                      _activeStepIndex = index;
                    },
                  );
                }
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
