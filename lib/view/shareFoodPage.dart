import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/model/sharedFoodModel.dart';
import 'package:uuid/uuid.dart';

class SharedFoodPage extends StatefulWidget {
  const SharedFoodPage({Key? key}) : super(key: key);

  @override
  State<SharedFoodPage> createState() => _SharedFoodPageState();
}

class _SharedFoodPageState extends State<SharedFoodPage> {
  final _formKey = GlobalKey<FormState>();
  String? _foodName;
  double? _price;
  String? _description;
  final RxString _imagePath = ''.obs;
  XFile? _image;

  // final _image

  final FoodController foodController = Get.find<FoodController>();
  final MemberController memberController = Get.find<MemberController>();

  @override
  Widget build(BuildContext context) {
    ShareFoodVM pageVM = Get.put(ShareFoodVM());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Share Food',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Color.fromRGBO(56, 56, 56, 1),
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 164, 91, 1),
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  color: Colors.black38,
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  // child: _image == null
                  //     ? const Icon(Icons.photo_size_select_actual_outlined)
                  //     : Image.network(
                  //         'https://occ-0-3934-2774.1.nflxso.net/dnm/api/v6/6AYY37jfdO6hpXcMjf9Yu5cnmO0/AAAABa14QAJ79YgjfK-XCytJltmR41JBxgraB8grW2895cWIB1nitMZcnDueux0WKuHDYMATX4QH1BhsZieHDbhVM1G7vrlFolk5dPDx.jpg?r=c54'),
                  child: Obx(
                    () {
                      if (pageVM.hasImage.value) {
                        return Image.file(
                          File(_imagePath.value),
                        );
                      } else {
                        return const Icon(
                            Icons.photo_size_select_actual_outlined);
                        // return Image.network(
                        //     'https://occ-0-3934-2774.1.nflxso.net/dnm/api/v6/6AYY37jfdO6hpXcMjf9Yu5cnmO0/AAAABa14QAJ79YgjfK-XCytJltmR41JBxgraB8grW2895cWIB1nitMZcnDueux0WKuHDYMATX4QH1BhsZieHDbhVM1G7vrlFolk5dPDx.jpg?r=c54');
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Food Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Color.fromRGBO(56, 56, 56, 1),
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Food Name',
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 3) {
                            return 'Please input food name';
                          }
                          return null;
                        },
                        onSaved: (newValue) => _foodName = newValue,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Price',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Color.fromRGBO(56, 56, 56, 1),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Rp. 99.999',
                          // prefix: Text(
                          //   'Rp. ',
                          //   style: TextStyle(
                          //     color: Colors.black54,
                          //   ),
                          // ),
                          // prefixIcon: Icon(Icons.attach_money_rounded),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please input food price';
                          } else if (double.tryParse(value) == null) {
                            return 'Please input number';
                          }
                          return null;
                        },
                        onSaved: (newValue) => _price = double.parse(newValue!),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Color.fromRGBO(56, 56, 56, 1),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Input descriptions',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        maxLines: 7,
                        onSaved: (newValue) => _description = newValue,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Food Image',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Color.fromRGBO(56, 56, 56, 1),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 40,
                        width: 100,
                        child: TextButton(
                          onPressed: () async {
                            _image = await foodController.pickImage();
                            _imagePath.value = _image!.path;
                            pageVM.hasImage.value = true;
                          },
                          child: const Text(
                            'Add Image',
                            style: TextStyle(
                              color: Color.fromRGBO(56, 56, 56, 1),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 150,
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                  Colors.redAccent,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 150,
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                  Colors.greenAccent,
                                ),
                              ),
                              onPressed: () async {
                                await EasyLoading.show(
                                  dismissOnTap: false,
                                  maskType: EasyLoadingMaskType.black,
                                );
                                final form = _formKey.currentState;
                                if (_image == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(duration: Duration(seconds: 1),
                                          content:
                                              Text('Please input an image')));
                                } else if (form!.validate()) {
                                  form.save();
                                  var sharedFoodImageURL = await foodController
                                      .imgSharedFoodDataToStorage({
                                    'file': _image!,
                                    'memberID':
                                        memberController.member.value.memberID,
                                  });

                                  var uuid = const Uuid();
                                  String sharedFoodID = uuid.v4();
                                  var sf = SharedFood(
                                    detailNotes: _description ?? '',
                                    price: _price ?? 0,
                                    sharedFoodName: _foodName ?? '',
                                    sharedFoodID: sharedFoodID,
                                    sharedFoodImageURL: sharedFoodImageURL!,
                                    memberID:
                                        memberController.member.value.memberID,
                                    status: 'onsale',
                                    date: DateTime.now(),
                                    memberName:
                                        memberController.member.value.name,
                                  );


                                  await foodController
                                      .addNewSharedFoodData(sf.toMap());
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(duration: Duration(seconds: 1),content: Text('Share food added')));
                                    Navigator.pop(context);
                                  }
                                }
                                EasyLoading.dismiss();
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShareFoodVM extends GetxController {
  final RxBool hasImage = false.obs;
}
