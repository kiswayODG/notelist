import 'package:flutter/material.dart';

import 'generic_dialog.dart';


Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Supprier',
    content: "Êtes-vous sûr de vouloir supprimer cet élément ?",
    optionsBuilder: () => {
      'Annuler': false,
      'Oui': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
