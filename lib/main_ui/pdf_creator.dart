import 'dart:developer';
import 'dart:io';
import 'dart:io' as Io;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

abstract class PdfUtils {
  Future createPdf(String namaMahasiswa, String nim) async {
    var dir = Directory("/storage/emulated/0/FlutLab/Sent");
    if (!dir.existsSync()) {
      await Io.Directory("${dir.path}").create(recursive: true);
    }

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        // Ukuran kertas sesuaikan dengan kebutuhan
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Container(
            child: pw.Column(
              children: [
                pw.BarcodeWidget(
                  data: nim,
                  height: 50,
                  barcode: pw.Barcode.code39(),
                ),

                /// Row Name
                pw.SizedBox(height: 16),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        "Nama",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        ": $namaMahasiswa",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                /// Row NIM (Nomor Induk Mahasiswa)
                pw.SizedBox(height: 8),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        "NIM: ",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        ": $nim",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );

    /// Membuat atau mengconvert ke bytes data
    Uint8List dataBytes = await doc.save();

    /// Membuat filenya berdasarkan namanya berdasarkan nim
    final file = File("${dir.path}/$nim.pdf");

    /// Menyimpan file berdasarkan directory yang kita buat
    await file.writeAsBytes(dataBytes);
    return file.path;
  }

  Future<String> sendWhatsapp(String path) async {
    const platform = const MethodChannel("whatsappShare");
    String numPhone = "083813963166";

    try {
      var result = await platform.invokeMethod("sharePdf", {
        "filePath": "$path",
        "phone": "$numPhone",
      });
      log("Res $result");
    } catch (e) {
      log("Exception $e");
    }
  }
}

class PdfPage extends StatefulWidget {
  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> with PdfUtils {
  TextEditingController namaMahasiswa = TextEditingController();
  TextEditingController nim = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              /// Inputan PDF

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: namaMahasiswa,
                      decoration: InputDecoration(
                        hintText: "Nama mahasiswa",
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: nim,
                      decoration: InputDecoration(
                        hintText: "NIM",
                      ),
                    ),
                  ),
                ],
              ),

              /// Add new Button
              Row(
                children: [
                  MaterialButton(
                    child: Text("Scan Barcode"),
                    onPressed: () {},
                  ),
                  MaterialButton(
                    child: Text("Send to Whatsapp"),
                    onPressed: () {
                      createPdf(namaMahasiswa.text, nim.text).then((value) {
                        sendWhatsapp(value);
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
