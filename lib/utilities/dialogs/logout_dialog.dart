import 'package:flutter/material.dart';

import 'generic_dialog.dart';


Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Se déconnecter',
    content: "Êtes-vous sûr de vouloir vous déconnecter ?",
    optionsBuilder: () => {
      'Annuler': false,
      'Se déconnecter': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
