import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_service.dart';

import '../../services/auth/auth_service.dart';
import '../../util/constants/routes.dart';
import '../custom_widgets/note_card.dart';

class AllNotesView extends StatefulWidget {
  const AllNotesView({super.key});

  @override
  State<AllNotesView> createState() => _AllNotesViewState();
}

class _AllNotesViewState extends State<AllNotesView> {
  final _dragSelectGridViewController = DragSelectGridViewController();
  final CloudStorageService _notesService = CloudStorageService();

  String get userId => AppAuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _dragSelectGridViewController.addListener(_scheduleRebuild);
    super.initState();
  }

  @override
  void dispose() {
    _dragSelectGridViewController.removeListener(_scheduleRebuild);
    super.dispose();
  }

  void _scheduleRebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _notesService.allNotes(ownerUserId: userId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allNotes = snapshot.data as Iterable<CloudNote>;
              final isSelecting =
                  _dragSelectGridViewController.value.isSelecting;
              final title = isSelecting
                  ? '${_dragSelectGridViewController.value.amount} items selected'
                  : null;
              return Scaffold(
                appBar: AppBar(
                  elevation: 2,
                  title: title != null ? Text(title) : null,
                  leading: isSelecting ? const CloseButton() : Container(),
                ),
                body: DragSelectGridView(
                    itemCount: allNotes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 2.0),
                    itemBuilder:
                        (BuildContext context, int index, bool selected) {
                      final note = allNotes.elementAt(index);
                      return NoteCard(
                        note: note,
                        onTap: () => Navigator.of(context).pushNamed(
                            noteEditorExistingNoteRoute,
                            arguments: {'updatedNote': note}),
                        isSelected: selected,
                      );
                    }),
              );
            } else {
              return const GFLoader(
                type: GFLoaderType.square,
              );
            }
          default:
            return const GFLoader(
              type: GFLoaderType.square,
            );
        }
      },
    );
  }
}
