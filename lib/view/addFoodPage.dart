import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/model/foodModel.dart';
import 'package:uuid/uuid.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({Key? key}) : super(key: key);

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final _formKey = GlobalKey<FormState>();
  String? _foodName;
  double? _price;
  String? _description;
  int? _qty;
  final RxString _imagePath = ''.obs;
  XFile? _image;

  late final AddFoodVM pageVM;

  @override
  void initState() {
    // TODO: implement initState
    pageVM = Get.put(AddFoodVM());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Get.delete<AddFoodVM>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Food',
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
                        'Qty',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Food Qty',
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
                            return 'Please input food quantity';
                          } else if (int.tryParse(value) == null) {
                            return 'Please input number';
                          }
                          return null;
                        },
                        onSaved: (newValue) => _qty = int.parse(newValue!),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
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
                            _image = await pageVM.foodController.pickImage();
                            _imagePath.value = _image!.path;
                            pageVM.hasImage.value = true;
                          },
                          child: const Text(
                            'Add Image',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(
                          //   height: 40,
                          //   width: 150,
                          //   child: ElevatedButton(
                          //     style: const ButtonStyle(
                          //       backgroundColor:
                          //           MaterialStatePropertyAll<Color>(
                          //         Colors.redAccent,
                          //       ),
                          //     ),
                          //     onPressed: () {},
                          //     child: const Text(
                          //       'Cancel',
                          //       style: TextStyle(
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //   ),
                          // ),
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
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            duration: Duration(seconds: 1),
                                            content:
                                                Text('Please input an image')));
                                  }
                                } else if (form!.validate()) {
                                  form.save();
                                  var uuid = const Uuid();
                                  String foodID = uuid.v4();
                                  var foodImageURL = await pageVM.foodController
                                      .imgFoodDataToStorage({
                                    'file': _image!,
                                    'shopID':
                                        pageVM.shopController.shop.value.shopID,
                                    'imgName': foodID,
                                  });
                                  var food = Food(
                                      price: _price ?? 0,
                                      detailNotes: _description ?? '',
                                      foodName: _foodName ?? '',
                                      foodID: foodID,
                                      foodImageURL: foodImageURL!,
                                      qty: _qty ?? 0,
                                      shopID: pageVM
                                          .shopController.shop.value.shopID);
                                  // // print(sf.toMap());
                                  //
                                  await pageVM.foodController
                                      .addNewFoodData(food.toMap());
                                  if (mounted) {
                                    EasyLoading.dismiss();
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

class AddFoodVM extends GetxController {
  final FoodController foodController = Get.find<FoodController>();
  final ShopController shopController = Get.find<ShopController>();

  final RxBool hasImage = false.obs;
}
