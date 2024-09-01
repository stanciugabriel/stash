import 'package:barcode_widget/barcode_widget.dart' as bar;
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class CardPreview extends StatefulWidget {
  final String name;
  final String code;
  final String format;
  const CardPreview(
      {required this.code,
      required this.name,
      required this.format,
      super.key});

  @override
  State<CardPreview> createState() => _CardPreviewState();
}

class _CardPreviewState extends State<CardPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.name),
            widget.format == "BarcodeFormat.qrCode"
                ? bar.BarcodeWidget(
                    barcode: bar.Barcode.qrCode(),
                    data: widget.code,
                  )
                : bar.BarcodeWidget(
                    barcode: bar.Barcode.code128(),
                    data: widget.code,
                  )
          ],
        ),
      ),
    );
  }
}
