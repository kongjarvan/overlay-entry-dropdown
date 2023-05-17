import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final reasonList = ['설비 고장', '팁 교체', '조작 실수'];
  List<String?> selectedReason = [];
  final timeList = ['10', '20', '30', '40'];
  List<String?> selectedTime = [];

  OverlayEntry? overlayEntry;
  var layerList = [];
  var overlayStsList = [];
  bool isOpened = false;
  int submitTime = 0;
  num? delayedTime;

  // 드롭다운 생성.
  void createReasonOverlay(int index) {
    if (overlayEntry == null) {
      overlayEntry = _customDropdown(layerList[index].first, reasonList, index);
      Overlay.of(context).insert(overlayEntry!);
      isOpened = true;
    }
  }

  void createTimeOverlay(int index) {
    if (overlayEntry == null) {
      overlayEntry = _customDropdown(layerList[index].last, timeList, index);
      Overlay.of(context).insert(overlayEntry!);
      isOpened = true;
    }
  }

  // 드롭다운 해제.
  void removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
    isOpened = false;
  }

  void addRow() {
    removeOverlay();
    layerList = [
      [LayerLink(), LayerLink()],
      ...layerList
    ];
    selectedReason = [null, ...selectedReason];
    selectedTime = ['10', ...selectedTime];
  }

  void deleteRow(int index) {
    removeOverlay();
    List<String?> newList1 = [...selectedReason];
    newList1.removeAt(index);
    selectedReason = newList1;

    List<String?> newList2 = [...selectedTime];
    newList2.removeAt(index);
    selectedTime = newList2;

    var newList3 = [...layerList];
    newList3.removeAt(index);
    layerList = newList3;
  }

  @override
  void initState() {
    addRow();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        removeOverlay();
      },
      child: Scaffold(
        appBar: AppBar(title: Text('title')),
        body: Center(
          child: Column(
            children: List.generate(
              layerList.length,
              (index) {
                return buildRow(index);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRow(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            if (isOpened == true) {
              removeOverlay();
            }
            createReasonOverlay(index);
          },
          child: CompositedTransformTarget(
            link: layerList[index].first,
            child: Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(),
              ),
              alignment: Alignment.center,
              child: Text(selectedReason[index] ?? ''),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            if (isOpened == true) {
              removeOverlay();
            }
            createTimeOverlay(index);
          },
          child: CompositedTransformTarget(
            link: layerList[index].last,
            child: Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(),
              ),
              alignment: Alignment.center,
              child: Text(selectedTime[index] ?? ''),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              if (index == 0) {
                addRow();
                return;
              }
              deleteRow(index);
            });
          },
          child: Container(
            decoration: BoxDecoration(border: Border.all()),
            height: 50,
            width: 100,
            alignment: Alignment.center,
            child: Text(index == 0 ? 'add' : 'delete'),
          ),
        )
      ],
    );
  }

  OverlayEntry _customDropdown(
      LayerLink layerLink, List<String> list, int rowIndex) {
    return OverlayEntry(
      maintainState: true,
      builder: (context) {
        return Positioned(
          width: 100,
          child: CompositedTransformFollower(
            link: layerLink,
            offset: const Offset(0, 50),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: List.generate(list.length, (index) {
                  return buildContent(list, rowIndex, index);
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildContent(List<String> list, int rowIndex, int index) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: CupertinoButton(
        onPressed: () {
          setState(() {
            if (list == reasonList) {
              print('$rowIndex');
              selectedReason[rowIndex] = list[index];
            }
            if (list == timeList) {
              print('$rowIndex');
              selectedTime[rowIndex] = list[index];
            }
            removeOverlay();
          });
        },
        child: Text(
          list[index],
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
