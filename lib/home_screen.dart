import 'package:final_project/main_ui/pdf_creator.dart';
import 'package:final_project/main_ui/print_thermal.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Column(
        children: [
          MaterialButton(
            child: Text("Make PDF"),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => PdfPage()));
            },
          ),
          MaterialButton(
            child: Text("Pagination Quiz"),
            onPressed: () {},
          ),
          MaterialButton(
            child: Text("Print Thermal"),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => PrinterThermal()));
            },
          ),
        ],
      ),
    );
  }
}
