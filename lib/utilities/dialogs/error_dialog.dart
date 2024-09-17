import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: "Une erreur s'est produite",
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
