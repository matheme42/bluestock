import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bluestock/context/context.dart';
import 'package:bluestock/database/models/inventory.dart';
import 'package:bluestock/database/shared_preference_controller.dart';
import 'package:bluestock/views/helper/bluestock.dart';
import 'package:bluestock/views/helper/popup.dart';
import 'package:bluestock/views/inventory_view/inventory_resume.dart';
import 'package:bluestock/views/welcome_view/conditons_generale.dart';
import 'package:bluestock/views/welcome_view/form_view/form_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AutoSizeGroup autoSizeGroup = AutoSizeGroup();
    var appContext = BluestockContext.of(context);
    return Scaffold(
        backgroundColor: const Color(0xFF112473),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Padding(padding: const EdgeInsets.all(6),
          child: Image.asset('assets/logo.png')),
          title: Text('title'.tr),
          actions: [
            ValueListenableBuilder<bool>(
                valueListenable: appContext.cguAccepted,
                child: IconButton(
                    onPressed: () => inventoryNewPopup(context),
                    icon: const Icon(Icons.add)),
                builder: (context, value, child) {
                  return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: value == false ? const SizedBox.shrink() : child!);
                }),
          ],
        ),
        body: ValueListenableBuilder<bool>(
            valueListenable: appContext.cguAccepted,
            child: ValueListenableBuilder(
                valueListenable: appContext.updater,
                builder: (context, value, _) {
                  return ListView.builder(
                      itemCount: appContext.inventories.length,
                      itemBuilder: (context, index) {
                        Inventory inventory =
                            appContext.inventories.reversed.toList()[index];
                        return ListTile(
                          onTap: () {
                            if (inventory.done == true) {
                              inventoryResumePopup(context, inventory);
                              return;
                            }
                            appContext.currentInventory.value = inventory;
                          },
                          onLongPress: () {
                            if (inventory.done == true) {
                              inventoryResumePopup(context, inventory);
                              return;
                            }
                            appContext.currentInventory.value = inventory;
                          },
                          title: AutoSizeText(
                            inventory.site.name,
                            group: autoSizeGroup,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                            maxLines: 1,
                          ),
                          subtitle: const AutoSizeText(
                            '',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                            maxLines: 1,
                          ),
                          isThreeLine: true,
                          trailing: AutoSizeText(
                            DateFormat.yMd().format(inventory.date),
                            style: const TextStyle(color: Colors.white),
                          ),
                          leading: !inventory.done
                              ? SizedBox(
                                  width: 70,
                                  child: AnimatedTextKit(
                                    repeatForever: true,
                                    animatedTexts: [
                                      FlickerAnimatedText('in_progress'.tr,
                                          entryEnd: 0.3,
                                          textStyle: const TextStyle(
                                              color: Colors.purple)),
                                    ],
                                  ),
                                )
                              : const SizedBox(
                                  width: 70,
                                ),
                        );
                      });
                }),
            builder: (context, value, child) {
              return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: value == false ? const ConditonsGenerale() : child!);
            }),
        bottomNavigationBar: ValueListenableBuilder<bool>(
            valueListenable: BluestockContext.of(context).cguAccepted,
            child: ListTile(
              onLongPress: () => BluestockContext.of(context).cguAccepted.value = false,
              onTap: () => BluestockContext.of(context).cguAccepted.value = false,
              title: AutoSizeText(
                'all_right'.tr,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.language_outlined,
                  color: Colors.white70,
                ),
                onPressed: () {
                  if (appContext.language.toString() == 'fr_FR') {
                    Locale l = const Locale('en', 'US');
                    SharedPreferenceController.setLanguage(l).then((_) {
                      appContext.language = l;
                      Get.updateLocale(l);
                    });
                    return ;
                  }
                  Locale l = const Locale('fr', 'FR');
                  SharedPreferenceController.setLanguage(l).then((_) {
                    appContext.language = l;
                    Get.updateLocale(l);
                  });
                },
              ),
              trailing: IconButton(
                  icon: const Icon(Icons.help),
                  color: Colors.white70,
                  onPressed: () => helpPopup(context, const HelpBluestock())),
            ),
            builder: (context, value, child) {
              return value == true ? child! : const SizedBox.shrink();
            }));
  }
}
