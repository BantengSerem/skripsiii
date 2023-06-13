import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/model/sharedFoodModel.dart';

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
              onPressed: () {
                Navigator.of(context).pop();
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
        title: const Text('Share Food'),
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
          child: Column(
            children: [
              Container(
                color: Colors.black38,
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: Image.network(widget.sf.sharedFoodImageURL),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shared by : ${widget.sf.memberName}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => Text(
                        'Distance ${pageVM.distance.value.toString().substring(0, 2)}.${pageVM.distance.value.toString().substring(2, 4)} KM',
                        style: const TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
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
                        border: Border.all(width: 1, color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
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
                            style: TextStyle(color: Colors.green),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await pageVM.test();
      //   },
      // ),
    );
  }
}

class OrderShareFoodVM extends GetxController {
  final FoodController foodController = Get.find<FoodController>();
  final MemberController memberController = Get.find<MemberController>();
  final SharedFood sf;
  final RxDouble distance = 5.0.obs;

  OrderShareFoodVM({required this.sf});

  Future<void> test() async {
    var m = memberController.member.value;
    await memberController.getMemberAddress(m.memberID);
  }

  void init() async {
    var m = memberController.member.value;
    var sfa = await memberController.getMemberAddress(m.memberID);
    distance.value = foodController.calculateDistance(
      lat1: m.latitude,
      lon1: m.longitude,
      lat2: sfa.latitude,
      lon2: sfa.longitude,
    );
  }
}
