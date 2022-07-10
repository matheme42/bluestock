import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CodeBarSvgTile extends StatelessWidget {

  final String svg;
  final String data;
  const CodeBarSvgTile({
    Key? key,
    required this.svg,
    required this.data
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(data, textAlign: TextAlign.center, textScaleFactor: 2,),
          SvgPicture.string(svg, fit: BoxFit.contain),
        ],
      ),
    );
  }

}

class CodeBarDemonstrator extends StatelessWidget {
  const CodeBarDemonstrator({Key? key}) : super(key: key);

  /// Create barcodes
  List<Widget> buildBarcode() {
    List<Widget> barcodes = [];

    final svg2 = Barcode.code128().toSvg('22', width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg2, data: 'code128'));

    final svg3 = Barcode.code39().toSvg('22', width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg3, data: 'code39'));

    final svg4 = Barcode.code93().toSvg('22', width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg4, data: 'code93'));

    final svg5 = Barcode.itf().toSvg('22', width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg5, data: 'itf'));

    final svg6 = Barcode.ean13().toSvg("1234567890128", width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg6, data: 'ean13'));

    final svg7 = Barcode.upcE().toSvg("0123456", width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg7, data: 'upcE'));

    final svg8 = Barcode.aztec().toSvg('22', width: 200, height: 200);
    barcodes.add(CodeBarSvgTile(svg: svg8, data: 'aztec'));

    final svg = Barcode.qrCode().toSvg('22', width: 200, height: 200);
    barcodes.add(CodeBarSvgTile(svg: svg, data: 'qrCode'));
    return barcodes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: buildBarcode());
  }

}