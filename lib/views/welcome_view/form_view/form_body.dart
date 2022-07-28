import 'package:bluestock/database/models/inventory.dart';
import 'package:bluestock/views/welcome_view/form_view/articles_field.dart';
import 'package:bluestock/views/welcome_view/form_view/date_field.dart';
import 'package:bluestock/views/welcome_view/form_view/process_field.dart';
import 'package:bluestock/views/welcome_view/form_view/storage_zone_field.dart';
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
