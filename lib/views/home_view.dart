import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mynotes/custom_widgets/reused_widgets.dart';
import 'package:mynotes/util/constants/colors.dart';
import 'package:mynotes/views/all_notes_view.dart';
import 'package:mynotes/views/favorite_notes_view.dart';

import '../custom_widgets/button.dart';
import '../custom_widgets/icon.dart';
import '../services/auth/auth_service.dart';
import '../util/constants/routes.dart';

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
    return TabBarView(
      controller: _tabController,
      children: [AllNotesView(), const FavoriteNotesView()],
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
                        showToast('Sign out cancelled');
                      }),
                ],
              )
            ],
          );
        }).then((value) => value ?? false);
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
      child: const Icon(
        Icons.add_box,
        color: CustomColors.onPrimary,
      ),
    );
  }
}
