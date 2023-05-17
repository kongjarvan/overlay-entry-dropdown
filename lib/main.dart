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
  bool isOpened1 = false;
  bool isOpened2 = false;

  OverlayEntry? overlayEntry;
  var layerList = [];

  // 열 추가
  void addRow() {
    layerList.add([LayerLink(), LayerLink()]);
    selectedReason = [null, ...selectedReason];
    selectedTime = ['10', ...selectedTime];
  }

  // 열 제거
  void deleteRow(int index) {
    layerList.removeAt(index);
    selectedReason.removeAt(index);
    selectedTime.removeAt(index);
  }

  // 드롭다운 생성.
  void createReasonOverlay(int index) {
    if (overlayEntry == null) {
      overlayEntry = _customDropdown(layerList[index].first, reasonList, index);
      Overlay.of(context).insert(overlayEntry!);
      isOpened1 = true;
    }
  }

  void createTimeOverlay(int index) {
    if (overlayEntry == null) {
      overlayEntry = _customDropdown(layerList[index].last, timeList, index);
      Overlay.of(context).insert(overlayEntry!);
      isOpened2 = true;
    }
  }

  // 드롭다운 해제.
  void removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
    isOpened1 = false;
    isOpened2 = false;
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
            if (isOpened1 == false) {
              createReasonOverlay(index);
              return;
            }
            removeOverlay();
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
            if (isOpened2 == false) {
              createTimeOverlay(index);
              return;
            }
            removeOverlay();
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
