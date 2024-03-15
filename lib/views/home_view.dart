import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/util/constants/colors.dart';
import 'package:mynotes/views/notes_view/multi_notes_view.dart';

import '../services/auth/auth_service.dart';
import '../services/cloud/cloud_note.dart';
import '../services/cloud/cloud_storage_service.dart';
import '../util/constants/routes.dart';
import 'custom_widgets/icon.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late bool _isSearching;
  late final TabController _tabController;
  late final FocusNode _searchFocusNode;
  late final TextEditingController _searchController;
  final CloudStorageService _notesService = CloudStorageService();
  late Iterable<CloudNote> _allNotes;
  late Iterable<CloudNote> _favoriteNotes;

  String get userId => AppAuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _isSearching = false;
    _searchFocusNode = FocusNode();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: _body(),
        floatingActionButton: _fab(),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 10,
      flexibleSpace: Container(
        height: AppBar().preferredSize.height,
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(
              color: CustomColors.primary, width: _isSearching ? 3.0 : 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
      bottom: _tabBar(),
      title: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for notes',
          border: InputBorder.none,
          prefixIcon: AppIcon(icon: _isSearching ? Icons.close : Icons.search),
        ),
        autofocus: false,
        focusNode: _searchFocusNode,
        onTap: () {
          setState(() {
            _isSearching = !_isSearching;
          });
          if (!_isSearching) {
            _searchController.text = '';
            _searchFocusNode.unfocus();
          }
        },
      ),
      actions: [
        Visibility(
          visible: !_isSearching,
          maintainState: true,
          maintainAnimation: true,
          child: IconButton(
              icon: const AppIcon(icon: Icons.account_circle),
              onPressed: () => context
                  .read<AppAuthBloc>()
                  .add(const AppAuthEventAccountSettings())),
        ),
      ],
    );
  }

  Widget _body() {
    return StreamBuilder(
      stream: _notesService.allNotes(ownerUserId: userId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              _allNotes = snapshot.data as Iterable<CloudNote>;
              _favoriteNotes = _allNotes.where((note) => note.isFavorite);
              return TabBarView(
                controller: _tabController,
                children: [
                  MultiNotesView(
                    allNotes: _allNotes,
                  ),
                  MultiNotesView(allNotes: _favoriteNotes)
                ],
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

  PreferredSizeWidget _tabBar() {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: CustomColors.primary,
      tabs: const [
        Tab(
          text: 'All Notes',
          icon: AppIcon(icon: Icons.home),
        ),
        Tab(
          text: 'Favorite Notes',
          icon: AppIcon(icon: Icons.favorite),
        )
      ],
      controller: _tabController,
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
      child: const Icon(Icons.add_box),
    );
  }
}
