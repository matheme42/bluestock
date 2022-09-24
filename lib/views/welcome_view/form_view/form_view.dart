import 'package:bluestock/context/context.dart';
import 'package:bluestock/controllers/controllers.dart';
import 'package:bluestock/models/models.dart';
import 'package:bluestock/views/helper_view/form.dart';
import 'package:bluestock/views/helper_view/popup.dart';
import 'package:bluestock/views/welcome_view/form_view/form_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';

void inventoryNewPopup(BuildContext context) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return NewInventoryForm();
    },
    animationType: DialogTransitionType.size,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(seconds: 1),
  );
}

class CustomValidator {
  static String? required(dynamic value) {
    if (value == null ||
        value == false ||
        ((value is Iterable || value is String || value is Map) &&
            value.length == 0)) {
      return "not_empty".tr;
    }
    return null;
  }
}

class NewInventoryForm extends StatelessWidget {
  NewInventoryForm({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier submitted = ValueNotifier(false);

  void submit(Inventory inventory, BuildContext context) async {
    inventory = await InventoryController().insert(inventory);
    Site newSite = Site();
    newSite.region = inventory.site.region;
    newSite.name = inventory.site.name;
    newSite = await SiteController().insert(newSite, inventory);
    for (var zone in inventory.site.zones) {
      var newZone = Zone();
      newZone.name = zone.name;
      newZone.num = zone.num;
      newSite.zones.add(await ZoneController().insert(newZone, newSite));
    }
    inventory.site = newSite;
    // ignore: use_build_context_synchronously
    BluestockContext appContext = BluestockContext.of(context);
    inventory.importArticle(appContext.articleStrings);
    appContext.inventories.add(inventory);
    appContext.currentInventory.value = inventory;
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Inventory inventory = Inventory();
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: const Color(0xFF112473),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('new_inventory'.tr),
          actions: [
            IconButton(
                onPressed: () => helpPopup(context, const HelpFileFormat()),
                icon: const Icon(
                  Icons.help,
                  color: Colors.white70,
                ))
          ],
        ),
        body: FormBody(inventory: inventory),
        bottomNavigationBar: Card(
          color: Colors.transparent,
          elevation: 3,
          child: ListTile(
            onTap: () {
              if (submitted.value == true) return;
              if (_formKey.currentState!.validate()) {
                submitted.value = true;
                submit(inventory, context);
              }
            },
            title: Text(
              'creer'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            visualDensity: const VisualDensity(vertical: -4),
          ),
        ),
      ),
    );
  }
}
