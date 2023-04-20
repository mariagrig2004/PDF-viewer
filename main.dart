import 'package:flutter/material.dart';
import 'dart:core';
import 'package:untitled/table/resize.dart';
import 'package:untitled/pdf.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'table-annotation-app',
        theme: ThemeData.dark(),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  late PDFDocument _pdf;
  List<Widget> children = [];
  bool _showDeleteButton = false;

  void _loadFile() async {
    //qashum enq pdf@ internetic - https://webhome.phy.duke.edu/~rgb/Class/intro_physics_1/intro_physics_1.pdf
    _pdf = await PDFDocument.fromURL('https://www.testdaf.de/fileadmin/testdaf/downloads/Modelltests_papierbasierter_TestDaF/Modelltest_1/Lesen/Modelltest_01_LV_Heft.pdf');
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  ResizebleWidget res = ResizebleWidget(
    child: Container(),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(-2.0),
        child: AppBar(),
      ),
      floatingActionButton: Padding(padding: const EdgeInsets.only(bottom: 36.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Visibility(
              visible: _showDeleteButton,
              child: Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 31.5),
                    child: Tooltip(
                      preferBelow: false,
                      message: "Delete Table",
                      child: FloatingActionButton(mini: true, backgroundColor: Colors.redAccent,
                          onPressed: () {
                            setState(() {
                              children.removeWhere((res) => isSelected);
                            });
                          },
                          child: const Icon(Icons.close, color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Tooltip(
                  preferBelow: false,
                  message: "Add Table",
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      setState(() {
                        children.add(res);
                        _showDeleteButton = true;
                        isSelected = false;
                      });
                    },
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      //body: Padding(
      //padding: const EdgeInsets.only(top: 30),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Center(
            child: Stack(
              children: [
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : PDFViewer(document: _pdf),
                Stack(
                  alignment: Alignment.center,
                  children: children,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
