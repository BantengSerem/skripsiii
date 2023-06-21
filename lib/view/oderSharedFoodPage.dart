import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/model/sharedFoodModel.dart';
import 'package:skripsiii/model/transctionShareFood.dart';
import 'package:uuid/uuid.dart';

class OrderedSharedFoodPage extends StatefulWidget {
  const OrderedSharedFoodPage({Key? key, required this.sf}) : super(key: key);
  final SharedFood sf;

  @override
  State<OrderedSharedFoodPage> createState() => _OrderedSharedFoodPageState();
}

class _OrderedSharedFoodPageState extends State<OrderedSharedFoodPage> {
  late final OrderShareFoodVM pageVM;

  @override
  void initState() {
    // TODO: implement initState
    // var a = RestaurantOrderMenuVM(shop: widget.shop);
    pageVM = Get.put(OrderShareFoodVM(sf: widget.sf));
    pageVM.init();
    // pageVM.shop = widget.shop;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Get.delete<OrderShareFoodVM>();
    super.dispose();
  }

  Future<void> alert({required BuildContext context}) async {
    // TextEditingController tc =
    //     TextEditingController(text: _count.value.toString());
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            textAlign: TextAlign.center,
            'Confirm Order',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Shared Food name : ${widget.sf.sharedFoodName}',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Confirm'),
              onPressed: () async {
                await EasyLoading.show(
                  dismissOnTap: false,
                  maskType: EasyLoadingMaskType.black,
                );
                var uuid = const Uuid();
                String tsfID = uuid.v4();
                var tsf = TransactionShareFoodModel(
                  sharedFoodName: widget.sf.sharedFoodName,
                  shareFoodTransactionID: tsfID,
                  memberBuyID: pageVM.memberController.member.value.memberID,
                  memberSellID: widget.sf.memberID,
                  date: DateTime.now(),
                  shareFoodID: widget.sf.sharedFoodID,
                  status: 'ongoing',
                  memberBuyName: pageVM.memberController.member.value.name,
                  memberSellName: widget.sf.memberName,
                  price: widget.sf.price,
                );
                var z = await pageVM.foodController
                    .createShareFoodTransaction(tsf: tsf);
                if (z) {
                  await pageVM.foodController
                      .shareFoodStatusToBought(widget.sf);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text('Successfully create transaction')));
                  }
                } else {
                  EasyLoading.dismiss();
                  if (mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text('Something went wrong')));
                  }
                }
                EasyLoading.dismiss();
                if (mounted) {
                  Navigator.of(context).pop();
                }
                // EasyLoading.dismiss();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              Container(
                color: Colors.black38,
                height: 220,
                width: MediaQuery.of(context).size.width,
                child: Image.network(widget.sf.sharedFoodImageURL),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Food Name ',
                      style: TextStyle(fontSize: 10
                          // fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.sf.sharedFoodName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Divider(
                      color: Color.fromRGBO(56, 56, 56, 1),
                      thickness: 1,
                      // indent: 20,
                      // endIndent: 20,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Shared by',
                      style: TextStyle(fontSize: 10
                          // fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      widget.sf.memberName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Divider(
                      color: Color.fromRGBO(56, 56, 56, 1),
                      thickness: 1,
                      // indent: 20,
                      // endIndent: 20,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Distance',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    Obx(
                        ()=> Text(
                        '${pageVM.distance.value.toStringAsFixed(2)} Km',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    const Divider(
                      color: Color.fromRGBO(56, 56, 56, 1),
                      thickness: 1,
                      // indent: 20,
                      // endIndent: 20,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        widget.sf.detailNotes,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: const Color.fromRGBO(
                            173, 173, 173, 1.0)),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.greenAccent
                      ),
                      height: 35,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () async {
                          await alert(context: context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          // color: Colors.white38,
                          child: const Text(
                            'Order',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(56, 56, 56, 1),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OrderShareFoodVM extends GetxController {
  final FoodController foodController = Get.find<FoodController>();
  final MemberController memberController = Get.find<MemberController>();
  final SharedFood sf;
  final RxDouble distance = 0.0.obs;

  OrderShareFoodVM({required this.sf});

  Future<void> test() async {
    var m = memberController.member.value;
    await memberController.getMemberAddress(m.memberID);
  }

  void init() async {
    var m = memberController.member.value;
    var sfa = await memberController.getMemberAddress(sf.memberID);
    distance.value = foodController.calculateDistance(
      lat1: m.latitude,
      lon1: m.longitude,
      lat2: sfa.latitude,
      lon2: sfa.longitude,
    );
  }
}
