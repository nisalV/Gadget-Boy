import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPDF extends StatefulWidget {
  final String pdfName,link;

  const ViewPDF(this.pdfName, this.link, {Key? key}) : super(key: key);


  @override
  _PdfState createState() => _PdfState();
}

class _PdfState extends State<ViewPDF> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SfPdfViewer.network(
            widget.link,
        )
      ),
    );
  }
}
