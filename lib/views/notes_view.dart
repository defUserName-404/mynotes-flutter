import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mynotes/custom_widgets/notes_card.dart';

import '../custom_widgets/button.dart';
import '../custom_widgets/reused_widgets.dart';
import '../services/auth/auth_service.dart';
import '../util/constants/routes.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late bool _isSearching;
  late final TextEditingController _searchController;
  final List<String> _data = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Fig',
    'Grape',
    'Lemon',
    'Mango',
    'Orange',
    'Papaya',
    'Peach',
    'Plum',
    'Raspberry',
    'Strawberry',
    'Watermelon',
  ];
  List<String> _filteredData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _searchController = TextEditingController();
    _filteredData = _data;
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

    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _filteredData = _data
          .where((element) => element
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).buttonTheme.colorScheme!.primary;
    final textColor = Theme.of(context).buttonTheme.colorScheme!.onPrimary;
    final List<NotesCard> notes = [
      const NotesCard(
        title: 'Hello',
        color: Colors.brown,
      ),
      const NotesCard(
        title: 'Hello',
        color: Colors.brown,
      ),
      const NotesCard(
        title: 'Hello',
        color: Colors.brown,
      ),
      const NotesCard(
        title: 'Hello',
        color: Colors.brown,
      ),
      const NotesCard(
        title: 'Hello',
        color: Colors.brown,
      ),
      const NotesCard(
        title: 'Hello',
        color: Colors.brown,
      ),
      const NotesCard(
        title: 'Hello',
        color: Colors.brown,
      ),
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search for notes',
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                  // Implement search functionality here
                )
              : Text(
                  'My Notes',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() => _isSearching = !_isSearching);
                if (_isSearching) {}
              },
            ),
            Visibility(
              visible: !_isSearching,
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  final signOut = await showLogOutDialog(context);
                  if (signOut) {
                    await AppAuthService.firebase().logout();
                    showToast(
                        'Successfully logged out', backgroundColor, textColor);
                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    });
                  } else {
                    showToast('Log out cancelled', backgroundColor, textColor);
                  }
                },
              ),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.green,
              ))
            : ListView.builder(
                itemCount: _filteredData.length,
                itemBuilder: (context, index) => ListTile(
                      title: Text(_filteredData[index]),
                    )),
        // body: Container(
        //   padding: const EdgeInsets.all(10),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       const SizedBox(
        //         height: 10.0,
        //       ),
        //       Expanded(
        //         child: GridView.count(
        //           crossAxisCount: 2,
        //           shrinkWrap: true,
        //           children: notes,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).buttonTheme.colorScheme!.inversePrimary,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.favorite_rounded))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showToast('Hello', backgroundColor, textColor);
            notes.add(const NotesCard(
              title: 'Hello',
              color: Colors.red,
              isFavorite: true,
            ));
          },
          tooltip: 'Add a new note',
          child: const Icon(Icons.add_box),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Future<bool> showLogOutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Sign out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              AppButton(
                  text: 'Yes, sign out',
                  icon: const Icon(Icons.outbond),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  }),
              AppButton(
                  text: 'Cancel',
                  icon: const Icon(Icons.outbond),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  }),
            ],
          );
        }).then((value) => value ?? false);
  }
}
