import 'package:flutter/material.dart';
import 'package:notelist/services/auth/auth_service.dart';

import '../../constants/routes.dart';
import '../../enums/menu_actions.dart';
import '../../services/crud/notes_service.dart';




class NoteViews extends StatefulWidget {
  const NoteViews({super.key});

  @override
  State<NoteViews> createState() => _NoteViewsState();
}

class _NoteViewsState extends State<NoteViews> {

  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    // TODO: implement initState
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title:const Text('Mes notes'),
        actions: [

          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(newNoteRoute);
          },
              icon: const Icon(Icons.add)),

          PopupMenuButton<MenuAction>(onSelected: (value) async {

            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);

                if(shouldLogout){
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_)=>false);
                }
                break;
            }
          },
            itemBuilder: (context) {
              return const [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: const Text("Se deconnecter"),
                ),
              ];
            },)
        ],
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,),
        body: FutureBuilder(future: _notesService.getOrCreateUser(email: userEmail),
            builder: (context,snapshot) {

              switch (snapshot.connectionState){
                case ConnectionState.done:
                  return StreamBuilder(stream: _notesService.allNotes,
                      builder: (context,snapshot){
                    switch(snapshot.connectionState) {
                      case ConnectionState.waiting:
                      // TODO: Handle this case.
                        return const Text("Chargment des notes ...");
                      case ConnectionState.active:
                      // TODO: Handle this case.
                      if(snapshot.hasData){
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        return ListView.builder(
                            itemBuilder: (context, index){
                              final note = allNotes[index];
                              return ListTile(
                                title: Text(note.text,maxLines: 1,softWrap: true,overflow: TextOverflow.ellipsis,),

                              );
                            },
                            itemCount: allNotes.length);
                      }else {
                        return CircularProgressIndicator();
                      }

                        return const Text("Chargment des notes ...");
                      default:
                        return const CircularProgressIndicator();
                    }
                      },
                  );
                default:
                  return CircularProgressIndicator();
              }
            })
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context){
  return showDialog(context: context, builder: (contex) {
    return AlertDialog(
      title: const Text("Déconnexion"),
      content: const Text("Etes vous sur de vous deconnecter?"),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop(false);
        }, child:const Text("Annuler")),
        TextButton(onPressed: () {
          Navigator.of(context).pop(true);
        }, child:const Text("Déconnecter"))
      ],
    );
  },
  ).then((value)=>value?? false);
}