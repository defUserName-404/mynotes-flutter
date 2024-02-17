import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mynotes/custom_widgets/notes_card.dart';
import 'package:mynotes/custom_widgets/reused_widgets.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/util/constants/colors.dart';

import '../custom_widgets/button.dart';
import '../custom_widgets/icon.dart';
import '../services/auth/auth_service.dart';
import '../util/constants/routes.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late bool _isSearching;
  late final TextEditingController _searchController;
  final List<NotesCard> _notes = [];
  List<NotesCard> _filteredNotes = [];
  bool _isLoading = false;
  late final NotesService _notesService;

  String get userEmail => AppAuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    _isSearching = false;
    _searchController = TextEditingController();
    _filteredNotes = _notes;
    _searchController.addListener(_performSearch);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _notesService.close();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      // _filteredNotes = _notes
      //     .where((element) => element.note.title
      //         .toLowerCase()
      //         .contains(_searchController.text.toLowerCase()))
      //     .toList();
      // _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: _body(),
        bottomNavigationBar: _bottomNavBar(),
        floatingActionButton: _fab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: _isSearching
          ? TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for notes',
                border: InputBorder.none,
              ),
              autofocus: true,
            )
          : Text(
              'My Notes',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
      actions: [
        IconButton(
          icon: AppIcon(icon: _isSearching ? Icons.close : Icons.search),
          onPressed: () {
            setState(() => _isSearching = !_isSearching);
            if (!_isSearching) {
              _searchController.text = '';
            }
          },
        ),
        Visibility(
          visible: !_isSearching,
          child: IconButton(
            icon: const AppIcon(icon: Icons.account_circle),
            onPressed: () async {
              final signOut = await _showLogOutDialog(context);
              if (signOut) {
                await AppAuthService.firebase().logout();
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _body() {
    return FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        final allNotes =
                            snapshot.data as Iterable<DatabaseNote>;
                        return NotesCard(
                          notes: allNotes,
                          onTap: (note) {
                            Navigator.of(context).pushNamed(
                                noteEditorExistingNoteRoute,
                                arguments: {'updatedNote': note});
                          },
                        );
                      default:
                        return const CircularProgressIndicator(
                          color: Colors.red,
                        );
                    }
                  });
            default:
              return const CircularProgressIndicator(
                color: Colors.green,
              );
          }
        });
  }

  Future<bool> _showLogOutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Sign out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AppButton(
                      text: 'Yes, sign out',
                      icon: const Icon(Icons.outbond),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      }),
                  AppButton(
                      text: 'Cancel',
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        showToast('Sign out cancelled');
                      }),
                ],
              )
            ],
          );
        }).then((value) => value ?? false);
  }

  Widget _bottomNavBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(onPressed: () {}, icon: const AppIcon(icon: Icons.home)),
          IconButton(
              onPressed: () {},
              icon: const AppIcon(icon: Icons.favorite_rounded))
        ],
      ),
    );
  }

  Widget _fab() {
    return FloatingActionButton(
      backgroundColor: CustomColors.primary,
      onPressed: () {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushNamed(noteEditorNewNoteRoute);
        });
      },
      tooltip: 'Add a new note',
      child: const Icon(
        Icons.add_box,
        color: CustomColors.onPrimary,
      ),
    );
  }
}
