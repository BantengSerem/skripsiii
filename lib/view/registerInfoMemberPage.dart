import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:skripsiii/constants/indonesiaRepo.dart';
import 'package:skripsiii/constants/route.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/helper/location.dart';
import 'package:skripsiii/model/addressModel.dart';
import 'dart:developer' as devtools show log;
import 'package:uuid/uuid.dart';
import 'package:skripsiii/controller/registerController.dart';
import 'package:skripsiii/model/memberModel.dart';

class RegisterInfoMemberPage extends StatefulWidget {
  const RegisterInfoMemberPage({super.key, this.password, this.email});

  final String? email;
  final String? password;

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

      if (FirebaseAuth.instance.currentUser == null) {
        var userCred =
            await registerController.registerMember(_email!, _password!);
        if (userCred != null) {
          Member m = Member(
            email: _email!,
            password: '',
            memberID: userCred.user!.uid.toString(),
            username: _username!,
            name: _name!,
            contacts: _phone!,
          );
          var uuid = const Uuid();
          String addressID = uuid.v4();

          var location = await LocationHelper.instance.getCurrentLocation();
          Address x = Address(
            addressID: addressID,
            userID: userCred.user!.uid.toString(),
            address: _address!,
            province: _province!,
            city: _city!,
            poscode: _postalCode!,
            latitude: location.latitude,
            longitude: location.longitude,
          );
          bool a = await registerController.addMemberToFirebase(m);
          if (a) {
            m.latitude = x.latitude;
            m.longitude = x.longitude;

            memberController.member = m.obs;
          }
          bool b = await registerController.addAddressToFirebase(x);
          devtools.log('Submitted');
          return a && b;
        } else {
          await EasyLoading.dismiss();
        }
      } else {
        var user = FirebaseAuth.instance.currentUser;
        Member m = Member(
          email: _email!,
          password: '',
          memberID: user!.uid.toString(),
          username: _username!,
          name: _name!,
          contacts: _phone!,
        );

        var uuid = const Uuid();
        String addressID = uuid.v4();

        var location = await LocationHelper.instance.getCurrentLocation();
        Address x = Address(
          addressID: addressID,
          userID: user.uid.toString(),
          address: _address!,
          province: _province!,
          city: _city!,
          poscode: _postalCode!,
          latitude: location.latitude,
          longitude: location.longitude,
        );
        bool a = await registerController.addMemberToFirebase(m);
        if (a) {
          m.latitude = x.latitude;
          m.longitude = x.longitude;
          memberController.member = m.obs;
        }
        bool b = await registerController.addAddressToFirebase(x);
        devtools.log('Submitted');
        await EasyLoading.dismiss();
        return a && b;
      }
    }
    await EasyLoading.dismiss();

    return false;
  }

  List<Step> stepListMember() => _email == null
      ? [
          Step(
            state:
                _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
            title: const Text('Credentials'),
            content: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Email'),
                  validator: (value) =>
                      EmailValidator.validate(value!) ? null : 'Invalid Email',
                  onSaved: (newValue) => _email = newValue,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  obscureText: true,
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
        ]
      : [
          Step(
            state:
                _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
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
            state: _activeStepIndex == 1
                ? StepState.editing
                : _activeStepIndex > 1
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
          ),
        ];

  // List<Step> stepListMemberGoogle() =>

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      _email = FirebaseAuth.instance.currentUser?.email;
      _password = '';
    }
    provinces = repo.getProvinces();
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
                  await EasyLoading.show(
                    dismissOnTap: false,
                    maskType: EasyLoadingMaskType.black,
                  );
                  var a = await submitCommand();
                  if (a) {
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        botNavRouteMember,
                        (route) => false,
                      );
                    }
                  }
                  await EasyLoading.dismiss();
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
