import 'package:bluestock/context/context.dart';
import 'package:bluestock/shared_preferences/shared_preference_controller.dart';
import 'package:bluestock/widgets/HawkFabMenu/hawk_fab_menu.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ToolsMenu extends StatelessWidget {
  final HawkFabMenuController hawkFabMenuController;

  const ToolsMenu({Key? key, required this.hawkFabMenuController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appContext = BluestockContext.of(context);
    return ValueListenableBuilder<TorchState>(
        valueListenable: appContext.scannerController.torchState,
        builder: (context, state, child) {
        return ValueListenableBuilder<bool>(
            valueListenable: appContext.cameraFocus,
            builder: (context, value, child) {
            return ValueListenableBuilder(
                valueListenable: appContext.scannerController.cameraFacingState,
                builder: (context, state, child) {
                return HawkFabMenu(
                  blur: 0,
                  icon: AnimatedIcons.home_menu,
                    fabColor: Colors.deepPurple[700],
                    iconColor: Colors.white,
                    hawkFabMenuController: hawkFabMenuController,
                    items: [
                      HawkFabMenuItem(
                        label: 'Camera',
                        ontap: () => appContext.scannerController.switchCamera(),
                        icon: const Icon(Icons.cameraswitch),
                        color: Colors.deepPurple[400],
                      ),
                      HawkFabMenuItem(
                        label: 'Flash',
                        color: Colors.deepPurple[500],
                        ontap: () => appContext.scannerController.toggleTorch(),
                        icon:
                            appContext.scannerController.torchState.value == TorchState.off
                                ? const Icon(Icons.flash_off, color: Colors.grey)
                                : const Icon(Icons.flash_on, color: Colors.yellow),
                      ),
                      HawkFabMenuItem(
                        label: 'Filtre',
                        color: Colors.deepPurple[600],
                        ontap: () {
                          bool val = !appContext.cameraFocus.value;
                          SharedPreferenceController.setCameraFocus(val).then((value) {
                            appContext.cameraFocus.value = val;
                          });
                        },
                        icon: appContext.cameraFocus.value == false
                            ? const Icon(Icons.fullscreen, color: Colors.white)
                            : const Icon(Icons.center_focus_weak_sharp,
                                color: Colors.white),
                      ),
                    ],
                    body: const SizedBox.shrink());
              }
            );
          }
        );
      }
    );
  }
}
