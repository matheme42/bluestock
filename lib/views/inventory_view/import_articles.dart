import 'package:bluestock/context/context.dart';
import 'package:bluestock/dart/import.dart';
import 'package:flutter/material.dart';

class ImportArticle extends StatelessWidget {
  const ImportArticle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF112473),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'importer des articles',
            style: TextStyle(color: Colors.white),
          ),
          MaterialButton(
            onPressed: () {
              Import.articlesCsv(
                  context, BluestockContext.of(context).currentInventory.value);
            },
            child: FractionallySizedBox(
              widthFactor: 0.4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('importer', style: TextStyle(color: Colors.white)),
                  Icon(
                    Icons.upload_file,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
