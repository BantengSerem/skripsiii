import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final HistoryPageVM pageVM;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageVM = Get.put(HistoryPageVM());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          Material(
            elevation: 5,
            child: Container(
              color: Colors.blue,
              height: 50,
              child: Row(
                children: [
                  const SizedBox(
                    width: 25,
                  ),
                  Obx(
                    () => TextButton(
                      onPressed: () {
                        if (pageVM.currButton.value != 0) {
                          pageVM.buttonPressed(0);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: pageVM.activeButton[0]
                            ? const MaterialStatePropertyAll<Color>(
                                Colors.black)
                            : const MaterialStatePropertyAll<Color>(
                                Colors.black26),
                      ),
                      child: Text(
                        'Buy',
                        style: TextStyle(
                          color: pageVM.activeButton[0]
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Obx(
                    () => TextButton(
                      onPressed: () {
                        if (pageVM.currButton.value != 1) {
                          pageVM.buttonPressed(1);
                        }
                        pageVM.activeButton[1];
                      },
                      style: ButtonStyle(
                        backgroundColor: pageVM.activeButton[1]
                            ? const MaterialStatePropertyAll<Color>(
                                Colors.black)
                            : const MaterialStatePropertyAll<Color>(
                                Colors.black26),
                      ),
                      child: Text(
                        'Sell',
                        style: TextStyle(
                          color: pageVM.activeButton[1]
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => pageVM.isLoading.value
                ? LoadingAnimationWidget.threeArchedCircle(
                    color: Colors.lightBlue,
                    size: 50,
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, idx) {
                        return Container(
                          height: 90,
                          color: Colors.green,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class HistoryPageVM extends GetxController {
  RxList<bool> activeButton = [true, false].obs;
  RxInt currButton = 0.obs;
  RxBool isLoading = false.obs;

  void buttonPressed(int i) {
    activeButton[currButton.value] = false;
    activeButton[i] = true;
    currButton.value = i;
    print(activeButton);
  }

  Future<void> init() async {}
}
