import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mynotes/custom_widgets/notes_card.dart';
import 'package:mynotes/models/note.dart';

import '../custom_widgets/button.dart';
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

  @override
  void initState() {
    super.initState();
    for (int i = 0; i <= 10; i++) {
      _notes.add(NotesCard(
          note: Note(
              title: i < 3 ? "Hello $i" : "$i",
              color: Colors.brown,
              isFavorite: false)));
    }
    _isSearching = false;
    _searchController = TextEditingController();
    _filteredNotes = _notes;
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _filteredNotes = _notes
          .where((element) => element.note.title
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
      _isLoading = false;
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
          icon: Icon(_isSearching ? Icons.close : Icons.search),
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
            icon: const Icon(Icons.account_circle),
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
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          )
        : Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    children: _filteredNotes,
                  ),
                ),
              ],
            ),
          );
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_rounded))
        ],
      ),
    );
  }

  Widget _fab() {
    return FloatingActionButton(
      onPressed: () {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushNamed(noteCreateOrUpdateRoute);
        });
        _notes.add(NotesCard(
            note: Note(title: "Hello", color: Colors.red, isFavorite: true)));
      },
      tooltip: 'Add a new note',
      child: const Icon(Icons.add_box),
    );
  }
}
