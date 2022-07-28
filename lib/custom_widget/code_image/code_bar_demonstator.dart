import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CodeBarSvgTile extends StatelessWidget {
  final String svg;
  final String data;

  const CodeBarSvgTile({Key? key, required this.svg, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            data,
            textAlign: TextAlign.center,
            textScaleFactor: 2,
          ),
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

    final svg2 = Barcode.code128(
            useCode128A: true, useCode128B: false, useCode128C: false)
        .toSvg('22', width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg2, data: 'code128 A'));

    final svg21 = Barcode.code128(
            useCode128A: false, useCode128B: true, useCode128C: false)
        .toSvg('22', width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg21, data: 'code128 B'));

    final svg22 = Barcode.code128(
            useCode128A: false, useCode128B: false, useCode128C: true)
        .toSvg('22', width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg22, data: 'code128 C'));

    final svg3 = Barcode.code39().toSvg('22', width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg3, data: 'code39'));

    final svg4 = Barcode.code93().toSvg('22', width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg4, data: 'code93'));

    final svg5 = Barcode.itf().toSvg('22', width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg5, data: 'itf'));

    final svg50 =
        Barcode.itf16().toSvg('1540014128876782', width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg50, data: 'itf 16'));

    final svg51 =
        Barcode.itf14().toSvg('15400141288763', width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg51, data: 'itf 14'));

    final svg60 = Barcode.ean8().toSvg("96385074", width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg60, data: 'ean8'));

    final svg6 = Barcode.ean13().toSvg("1234567890128", width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg6, data: 'ean13'));

    final svg71 = Barcode.upcA().toSvg("012345678912", width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg71, data: 'upcA'));

    final svg7 = Barcode.upcE().toSvg("0123456", width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg7, data: 'upcE'));

    final svg70 = Barcode.isbn().toSvg("9783161484100", width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg70, data: 'isbn'));

    final svg80 = Barcode.codabar().toSvg("12345678", width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg80, data: 'codabar'));

    final svg81 = Barcode.pdf417().toSvg("12345678", width: 200, height: 80);
    barcodes.add(CodeBarSvgTile(svg: svg81, data: 'pdf 417'));

    final svg8 = Barcode.aztec().toSvg('22', width: 200, height: 200);
    barcodes.add(CodeBarSvgTile(svg: svg8, data: 'aztec'));

    final svg9 = Barcode.dataMatrix().toSvg('22', width: 200, height: 200);
    barcodes.add(CodeBarSvgTile(svg: svg9, data: 'dataMatrix'));

    final svg = Barcode.qrCode().toSvg('22', width: 200, height: 200);
    barcodes.add(CodeBarSvgTile(svg: svg, data: 'qrCode'));
    return barcodes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: buildBarcode());
  }
}
