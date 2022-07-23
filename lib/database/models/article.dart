import 'package:bluestock/database/models/model.dart';
import 'package:flutter/material.dart';

class Article extends Model {
  late String process;

  /// type de process lié a l'article
  late String codeProduct;

  /// code produit du livret
  late String commercialDenomination;

  /// denomination commercial
  late String dci;

  /// DCI
  late String internalDenomination;

  /// denomination internal
  late String family;

  /// famille
  late String underFamily;

  /// sous-famille
  late String countingUnit;

  /// unité de comptage
  late String referenceUnit;

  /// unité de référence
  late String brandLaboratoryReference;

  /// Référence marque / laboratoire
  late String code;

  /// Code Barre/Qrcode

  static final List<String> keysInfo = [
    'process',
    'code produit',
    'dénomination commercial',
    'DCI',
    'dénomination interne',
    'famille',
    'sous-famille',
    'unité de comptage',
    'unité de référence',
    'Référence marque / laboratoire',
    'Code Barre/Qrcode'
  ];

  void fromList(List<dynamic> data) {
    if (data.length < 11) return;
    process = data[0]?.toString().trim().toLowerCase() ?? '';
    codeProduct = data[1]?.toString().trim().toLowerCase() ?? '';
    commercialDenomination = data[2]?.toString().trim().toLowerCase() ?? '';
    dci = data[3]?.toString().trim().toLowerCase() ?? '';
    internalDenomination = data[4]?.toString().trim().toLowerCase() ?? '';
    family = data[5]?.toString().trim().toLowerCase() ?? '';
    underFamily = data[6]?.toString().trim().toLowerCase() ?? '';
    countingUnit = data[7]?.toString().trim().toLowerCase() ?? '';
    referenceUnit = data[8]?.toString().trim().toLowerCase() ?? '';
    brandLaboratoryReference = data[9]?.toString().trim().toLowerCase() ?? '';
    code = data[10]?.toString().trim().toLowerCase() ?? '';
  }

  Article copy() => Article()..fromMap(asMap());

  @override
  void fromMap(Map<String, dynamic> data) {
    data.containsKey('process') ? process = data['process'] : 0;
    data.containsKey('codeProduct') ? codeProduct = data['codeProduct'] : 0;
    data.containsKey('commercialDenomination') ? commercialDenomination = data['commercialDenomination'] : 0;
    data.containsKey('dci') ? dci = data['dci'] : 0;
    data.containsKey('internalDenomination') ? internalDenomination = data['internalDenomination'] : 0;
    data.containsKey('family') ? family = data['family'] : 0;
    data.containsKey('underFamily') ? underFamily = data['underFamily'] : 0;
    data.containsKey('countingUnit') ? countingUnit = data['countingUnit'] : 0;
    data.containsKey('referenceUnit') ? referenceUnit = data['referenceUnit'] : 0;
    data.containsKey('brandLaboratoryReference') ? brandLaboratoryReference = data['brandLaboratoryReference'] : 0;
    data.containsKey('code') ? family = data['code'] : 0;
  }

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> message = {};
    message['process'] = process.toString();
    message['codeProduct'] = codeProduct.toString();
    message['commercialDenomination'] = commercialDenomination.toString();
    message['dci'] = dci.toString();
    message['internalDenomination'] = internalDenomination.toString();
    message['family'] = family.toString();
    message['underFamily'] = underFamily.toString();
    message['countingUnit'] = countingUnit.toString();
    message['referenceUnit'] = referenceUnit.toString();
    message['brandLaboratoryReference'] = brandLaboratoryReference.toString();
    message['code'] = code.toString();
    message.addAll(super.asMap());
    return message;
  }

  void print() => debugPrint(asMap().toString());
}
