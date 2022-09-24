import 'package:bluestock/context/context.dart';
import 'package:bluestock/models/models.dart';
import 'package:bluestock/views/inventory_view/inventory_view.dart';
import 'package:bluestock/views/welcome_view/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BluestockContext appContext = BluestockContext.of(context);
    return SkeletonTheme(
      shimmerGradient: const LinearGradient(
        colors: [
          Color(0xFFD8E3E7),
          Color(0xFFC8D5DA),
          Color(0xFFD8E3E7),
        ],
        stops: [
          0.1,
          0.5,
          0.9,
        ],
      ),
      darkShimmerGradient: const LinearGradient(
        colors: [
          Color(0xFF222222),
          Color(0xFF242424),
          Color(0xFF2B2B2B),
          Color(0xFF242424),
          Color(0xFF222222),
        ],
        stops: [
          0.0,
          0.2,
          0.5,
          0.8,
          1,
        ],
        begin: Alignment(-2.4, -0.2),
        end: Alignment(2.4, 0.2),
        tileMode: TileMode.clamp,
      ),
      child: WillPopScope(
        onWillPop: () async {
          if (appContext.currentZone.value != null) {
            appContext.previousZone = appContext.currentZone.value;
            BluestockContext.of(context).scannerController.stop();
            appContext.currentZone.value = null;
            return false;
          }
          if (appContext.currentInventory.value != null) {
            appContext.previousZone = null;
            appContext.currentInventory.value = null;
          }
          return false;
        },
        child: ValueListenableBuilder<Inventory?>(
            valueListenable: appContext.currentInventory,
            builder: (context, inventory, _) {
              return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anm) {
                    return FadeTransition(opacity: anm, child: child);
                  },
                  child: inventory == null
                      ? const WelcomePage()
                      : InventoryView(inventory: inventory));
            }),
      ),
    );
  }
}
