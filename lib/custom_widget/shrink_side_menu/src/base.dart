import 'dart:math' show pi, min;

import 'package:flutter/material.dart';

/// Liquid Shrink Side Menu is compatible with [Liquid ui](https://pub.dev/packages/liquid_ui)
///
/// Create a SideMenu / Drawer
///
class SideMenu extends StatelessWidget {

  final ValueNotifier<bool> opened;

  final int _inverse;

  /// Widget that should be enclosed in sidemenu
  ///
  /// generally a [Scaffold] and should not be `null`
  final Widget child;

  /// Background color of the side inventory_view
  ///
  /// default: Color(0xFF112473)
  final Color? background;

  /// Radius for the child when side inventory_view opens
  final BorderRadius? radius;

  /// Close Icon
  final Icon? closeIcon;

  /// Menu that should be in side inventory_view
  ///
  /// generally a [SingleChildScrollView] with a [Column]
  final Widget menu;

  /// Maximum constrints for inventory_view width
  ///
  /// default: `275.0`
  final double maxMenuWidth;

  final Widget? extra;

  const SideMenu({
    Key? key,
    required this.child,
    this.background,
    this.radius,
    this.extra,
    required this.opened,
    this.closeIcon = const Icon(
      Icons.close,
      color: Color(0xFFFFFFFF),
    ),
    required this.menu,
    this.maxMenuWidth = 275.0,
    bool inverse = false,
  })  : assert(maxMenuWidth > 0),
        _inverse = inverse ? -1 : 1,
        super(key: key);

  double degToRad(double deg) => (pi / 180) * deg;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final statusBarHeight = mq.padding.top;

    return Stack(
      fit: StackFit.expand,
      children: [
        extra ?? const SizedBox.shrink(),
        Positioned(
          top: statusBarHeight + (closeIcon?.size ?? 25.0) * 2,
          bottom: 0.0,
          width: min(size.width * 0.70, maxMenuWidth),
          right: _inverse == 1 ? null : 0,
          child: menu,
        ),
        ValueListenableBuilder(
          valueListenable: opened,
          child: child,
          builder: (context, value, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastLinearToSlowEaseIn,
              transform: _getMatrix4(size),
              child: ClipRRect(borderRadius: _getBorderRadius(), child: child),
            );
          },
        ),
      ],
    );
  }

  BorderRadius _getBorderRadius() {
    if (opened.value) {
      return (radius ?? BorderRadius.circular(34.0));
    }
    return BorderRadius.zero;
  }

  Matrix4 _getMatrix4(Size size) {
    if (opened.value) {
      return Matrix4.identity()
        ..rotateZ(degToRad(-5.0 * _inverse))
        ..translate(min(size.width, maxMenuWidth) * _inverse,
            (size.height * 0.15))
        ..invertRotation();
    }
    return Matrix4.identity();
  }
}

