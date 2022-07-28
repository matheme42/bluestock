import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CodeImage extends StatelessWidget {
  final String code;
  final String? type;
  final BoxFit? fit;

  const CodeImage({Key? key, required this.code, required this.type, this.fit})
      : super(key: key);

  Widget buildBarcode() {
    double height = 80;
    if (type == 'BarcodeFormat.qrCode' ||
        type == 'BarcodeFormat.aztec' ||
        type == 'BarcodeFormat.dataMatrix') {
      height = 200;
    }
    Barcode bc = getBarcodeType(type);

    /// Create the Barcode
    final svgString = bc.toSvg(
      code,
      width: 200,
      height: height,
    );
    return SvgPicture.string(svgString, fit: fit ?? BoxFit.cover);
  }

  Barcode getBarcodeType(String? type) {
    if (type == null) return Barcode.code128();
    Map map = {};
    map['BarcodeFormat.code128'] = Barcode.code128();
    map['BarcodeFormat.code39'] = Barcode.code39();
    map['BarcodeFormat.code93'] = Barcode.code93();
    map['BarcodeFormat.itf'] = Barcode.itf();
    map['BarcodeFormat.ean8'] = Barcode.ean8();
    map['BarcodeFormat.ean13'] = Barcode.ean13();
    map['BarcodeFormat.upcA'] = Barcode.upcA();
    map['BarcodeFormat.upcE'] = Barcode.upcE();
    map['BarcodeFormat.aztec'] = Barcode.aztec();
    map['BarcodeFormat.isbn'] = Barcode.isbn();
    map['BarcodeFormat.pdf417'] = Barcode.pdf417();
    map['BarcodeFormat.codabar'] = Barcode.codabar();
    map['BarcodeFormat.dataMatrix'] = Barcode.dataMatrix();
    map['BarcodeFormat.qrCode'] = Barcode.qrCode();
    return map[type] ?? Barcode.code128();
  }

  @override
  Widget build(BuildContext context) {
    return buildBarcode();
  }
}
