import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bluestock/context/context.dart';
import 'package:bluestock/database/models/inventory.dart';
import 'package:bluestock/views/helper/bluestock.dart';
import 'package:bluestock/views/helper/popup.dart';
import 'package:bluestock/views/home_view/conditons_generale.dart';
import 'package:bluestock/views/home_view/home_app_bar.dart';
import 'package:bluestock/views/inventory_view/inventory_resume.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AutoSizeGroup autoSizeGroup = AutoSizeGroup();
    return Scaffold(
      backgroundColor: const Color(0xFF112473),
      appBar: CustomAppBar.home(context),
      body: ValueListenableBuilder<bool>(
          valueListenable: BluestockContext.of(context).cguAccepted,
          child: ValueListenableBuilder(
            valueListenable: BluestockContext.of(context).updater,
            builder: (context, value, _) {
              return ListView.builder(
                  itemCount: BluestockContext.of(context).inventories.length,
                  itemBuilder: (context, index) {
                    Inventory inventory = BluestockContext.of(context)
                        .inventories
                        .reversed
                        .toList()[index];

                    return ListTile(
                      onTap: () {
                        if (inventory.done == true) {
                          inventoryResumePopup(context, inventory);
                          return;
                        }
                        BluestockContext.of(context).currentInventory.value =
                            inventory;
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
                                  FlickerAnimatedText('En Cours',
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
            }
          ),
          builder: (context, value, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: value == false ? const ConditonsGenerale() : child!
            );
          }),
      bottomNavigationBar:  ValueListenableBuilder<bool>(
        valueListenable: BluestockContext.of(context).cguAccepted,
        child: ListTile(
          onTap: () => conditonsGeneralePopup(context),
          title: const AutoSizeText(
            'Tous droits reservés 2021',
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.add, color: Colors.transparent,),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.help),
            color: Colors.white70,
            onPressed: () => helpPopup(context, const HelpBluestock())
          ),
        ),
        builder: (context, value, child) {
          return value == true ? child! : const SizedBox.shrink();
        }
      )
    );
  }
}
