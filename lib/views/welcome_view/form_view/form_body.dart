import 'package:bluestock/models/models.dart';
import 'package:bluestock/views/welcome_view/form_view/field/articles_field.dart';
import 'package:bluestock/views/welcome_view/form_view/field/date_field.dart';
import 'package:bluestock/views/welcome_view/form_view/field/process_field.dart';
import 'package:bluestock/views/welcome_view/form_view/field/storage_zone_field.dart';
import 'package:flutter/material.dart';

class FormBody extends StatelessWidget {
  const FormBody({Key? key, required this.inventory}) : super(key: key);

  final Inventory inventory;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ProcessField(inventory: inventory),
            StorageZoneField(inventory: inventory),
            DateField(inventory: inventory),
            ArticlesField(inventory: inventory),
          ],
        ),
      ),
    );
  }
}
