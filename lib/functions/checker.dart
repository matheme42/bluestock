import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Checker {
  static int checkSites(List<List<dynamic>> data, BuildContext context) {
    int index = 0;
    for (var line in data) {
      index++;
      line.removeWhere((elm) => elm.toString().isEmpty);
      if (line.length != 4) {
        // ignore: use_build_context_synchronously
        showTopSnackBar(
            context,
            CustomSnackBar.error(
              maxLines: 10,
              textScaleFactor: 0.9,
              message:
                  "erreur ligne $index\n\ntous les champs doivent être remplis",
            ),
            displayDuration: const Duration(seconds: 5));
        return index;
      }
      try {
        int.parse(line[2].toString());
      } catch (_) {
        // ignore: use_build_context_synchronously
        showTopSnackBar(
            context,
            CustomSnackBar.error(
              maxLines: 10,
              textScaleFactor: 0.9,
              message:
                  "erreur ligne $index\n\nLe numero de zone ${line[2]} doit être un entier",
            ),
            displayDuration: const Duration(seconds: 5));
        return index;
      }

      var index2 = 0;
      for (var line2 in data) {
        index2++;
        if (index2 == index) break;
        if (line2[2] == line[2]) {
          // ignore: use_build_context_synchronously
          showTopSnackBar(
              context,
              CustomSnackBar.error(
                maxLines: 10,
                textScaleFactor: 0.9,
                message:
                    "erreur ligne $index\n\nLa zone ${line[2]} éxiste déjà ligne $index2",
              ),
              displayDuration: const Duration(seconds: 5));

          return index2;
        }
      }
    }
    return 0;
  }

  static int checkArticle(List<List<dynamic>> data, BuildContext context) {
    int index = 0;
    for (var line in data) {
      index++;
      if (line.length != 11) {
        // ignore: use_build_context_synchronously
        showTopSnackBar(
            context,
            CustomSnackBar.error(
              maxLines: 10,
              textScaleFactor: 0.9,
              message:
                  "erreur ligne $index\n\ntous les champs doivent être référencés",
            ),
            displayDuration: const Duration(seconds: 5));
        return index;
      }
      if (line[1] == '') {
        // ignore: use_build_context_synchronously
        showTopSnackBar(
            context,
            CustomSnackBar.error(
              maxLines: 10,
              textScaleFactor: 0.9,
              message:
                  "erreur ligne $index\n\nLe numéro de produit doit être renseigné",
            ),
            displayDuration: const Duration(seconds: 5));
      }

      if (line[2] == '') {
        // ignore: use_build_context_synchronously
        showTopSnackBar(
            context,
            CustomSnackBar.error(
              maxLines: 10,
              textScaleFactor: 0.9,
              message:
                  "erreur ligne $index\n\nLe nom de produit doit être renseigné",
            ),
            displayDuration: const Duration(seconds: 5));
      }

      try {
        int.parse(line[1].toString());
      } catch (_) {
        // ignore: use_build_context_synchronously
        showTopSnackBar(
            context,
            CustomSnackBar.error(
              maxLines: 10,
              textScaleFactor: 0.9,
              message:
                  "erreur ligne $index\n\nLe numéro de produit doit être un entier",
            ),
            displayDuration: const Duration(seconds: 5));
        return index;
      }

      var index2 = 0;
      for (var line2 in data) {
        index2++;
        if (index2 == index) break;
        if (line2[1] == line[1]) {
          // ignore: use_build_context_synchronously
          showTopSnackBar(
              context,
              CustomSnackBar.error(
                maxLines: 10,
                textScaleFactor: 0.9,
                message:
                    "erreur ligne $index\n\nLe numéro de produit ${line[1]} éxiste déjà ligne $index2",
              ),
              displayDuration: const Duration(seconds: 5));

          return index2;
        }
      }
    }
    return 0;
  }

  static int checkProcess(List<List<dynamic>> data, BuildContext context) {
    int index = 0;
    for (var line in data) {
      index++;

      if (line.length != 1 || line[0] == null || line[0] == '') {
        // ignore: use_build_context_synchronously
        showTopSnackBar(
            context,
            CustomSnackBar.error(
              maxLines: 10,
              textScaleFactor: 0.9,
              message: "erreur ligne $index\n\nligne vide",
            ),
            displayDuration: const Duration(seconds: 5));

        return index;
      }

      var index2 = 0;
      for (var line2 in data) {
        index2++;
        if (index2 == index) break;
        if (line2[0] == line[0]) {
          // ignore: use_build_context_synchronously
          showTopSnackBar(
              context,
              CustomSnackBar.error(
                maxLines: 10,
                textScaleFactor: 0.9,
                message:
                    "erreur ligne $index\n\nLe process ${line[0]} éxiste déjà ligne $index2",
              ),
              displayDuration: const Duration(seconds: 5));

          return index2;
        }
      }
    }
    return 0;
  }
}
