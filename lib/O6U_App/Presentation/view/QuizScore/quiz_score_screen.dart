import 'package:flutter/material.dart';


class QuizScorePage extends StatefulWidget {
  @override
  _QuizScorePageState createState() => _QuizScorePageState();
}

class _QuizScorePageState extends State<QuizScorePage> {
  final int rowCount = 10;
  List<List<TextEditingController>> controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < rowCount; i++) {
      controllers.add(List.generate(3, (index) => TextEditingController()));
    }
  }

  @override
  void dispose() {
    for (var row in controllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Widget buildTableCell(TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 48,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
          right: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF005B7F),
        elevation: 0,
        centerTitle: true,

        title: Text(
          'Quiz score',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
    child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      tableHeader('Student Name'),
                      tableHeader('Quiz 1'),
                      tableHeader('Quiz 2'),
                    ],
                  ),
                  ...controllers.map((row) {
                    return Row(
                      children: row.map((ctrl) => Expanded(child: buildTableCell(ctrl))).toList(),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget tableHeader(String title) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        height: 48,
        alignment: Alignment.centerLeft,
        color: Colors.grey.shade100,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}