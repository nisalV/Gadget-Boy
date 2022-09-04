import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

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
      body: const PDF().fromUrl(widget.link,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),),
    );
  }
}
