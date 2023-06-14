import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/model/foodModel.dart';
import 'package:skripsiii/model/shopModel.dart';
import 'package:uuid/uuid.dart';

class EditFoodPage extends StatefulWidget {
  const EditFoodPage({Key? key, required this.food}) : super(key: key);
  final Food food;

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  final _formKey = GlobalKey<FormState>();
  String? _foodName;
  double? _price;
  String? _description;
  int? _qty;
  final RxString _imagePath = ''.obs;
  XFile? _image;
  late final EditFoodVM pageVM;

  @override
  void initState() {
    // TODO: implement initState
    pageVM = Get.put(EditFoodVM());
    // _foodName = widget.food.foodName;
    // _price = widget.food.price;
    // _description = widget.food.detailNotes;
    // _qty = widget.food.qty;
    // _imagePath.value = widget.food.foodImageURL;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Get.delete<EditFoodVM>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Food'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
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
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  // child: _image == null
                  //     ? const Icon(Icons.photo_size_select_actual_outlined)
                  //     : Image.network(
                  //         'https://occ-0-3934-2774.1.nflxso.net/dnm/api/v6/6AYY37jfdO6hpXcMjf9Yu5cnmO0/AAAABa14QAJ79YgjfK-XCytJltmR41JBxgraB8grW2895cWIB1nitMZcnDueux0WKuHDYMATX4QH1BhsZieHDbhVM1G7vrlFolk5dPDx.jpg?r=c54'),
                  child: Obx(
                    () {
                      if (pageVM.hasImage.value) {
                        print("image file being shown");
                        return Image.file(
                          File(_imagePath.value),
                        );
                      } else if (pageVM.initialImageActive.value) {
                        return Image.network(widget.food.foodImageURL);
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
                        initialValue: widget.food.foodName,
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
                        initialValue: widget.food.price.toString(),
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
                        initialValue: widget.food.qty.toString(),
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
                        initialValue: widget.food.detailNotes,
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
                            pageVM.initialImageActive.value = false;
                            print('_image : ${_imagePath.value}');
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
                              onPressed: () async {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Confirm food deletion',
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      ),
                                      content: Text(
                                        'Food Name : ${widget.food.foodName}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await EasyLoading.show(
                                              dismissOnTap: false,
                                              maskType:
                                                  EasyLoadingMaskType.black,
                                            );
                                            var deleteSuccess = await pageVM
                                                .foodController
                                                .deleteFoodImage({
                                              'shopID': pageVM.shopController
                                                  .shop.value.shopID,
                                              'imgName': widget.food.foodID,
                                            });

                                            if (deleteSuccess) {
                                              await pageVM.foodController
                                                  .deleteFoodData({
                                                'foodID': widget.food.foodID,
                                              });
                                            }

                                            if (mounted) {
                                              EasyLoading.dismiss();
                                              // int count = 2;
                                              // Navigator.of(context).popUntil((_) => count-- <= 0);
                                              //
                                              Navigator.of(context).popUntil((route) => route.isFirst);
                                            }
                                            // Navigator.pop(context, 'OK');
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                'Delete',
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

                                if (form!.validate()) {
                                  form.save();

                                  String? foodImageURL;
                                  if (_image != null) {
                                    var deleteSuccess = await pageVM
                                        .foodController
                                        .deleteFoodImage({
                                      'shopID': pageVM
                                          .shopController.shop.value.shopID,
                                      'imgName': widget.food.foodID,
                                    });
                                    if (deleteSuccess) {
                                      foodImageURL = await pageVM.foodController
                                          .imgFoodDataToStorage({
                                        'file': _image!,
                                        'shopID': pageVM
                                            .shopController.shop.value.shopID,
                                        'imgName': widget.food.foodID,
                                      });
                                    } else {
                                      foodImageURL = widget.food.foodImageURL;
                                    }
                                  } else {
                                    foodImageURL = widget.food.foodImageURL;
                                  }

                                  var food = Food(
                                    price: _price ?? 0,
                                    detailNotes: _description ?? '',
                                    foodName: _foodName ?? '',
                                    foodID: widget.food.foodID,
                                    foodImageURL: foodImageURL!,
                                    qty: _qty ?? 0,
                                    shopID: '',
                                  );
                                  await pageVM.foodController
                                      .updateFoodData(food.toMap());

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

class EditFoodVM extends GetxController {
  final FoodController foodController = Get.find<FoodController>();
  final ShopController shopController = Get.find<ShopController>();

  final RxBool hasImage = false.obs;
  final RxBool initialImageActive = true.obs;

  Future<void> _showMyDialog(
      BuildContext context, String foodName, Function() func) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm food deletion',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          content: Text(
            'Food Name : $foodName',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await func();
                // Navigator.pop(context, 'OK');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
