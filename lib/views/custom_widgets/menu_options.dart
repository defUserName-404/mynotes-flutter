import 'package:flutter/material.dart';

enum MenuItem { save, toggleFavorite, share, delete }

const menuOptions = [
  {
    'text': 'Toggle Favorite',
    'action': MenuItem.toggleFavorite,
    'icon': Icons.favorite_rounded,
  },
  {
    'text': 'Delete',
    'action': MenuItem.delete,
    'icon': Icons.delete_rounded,
  },
  {
    'text': 'Share',
    'action': MenuItem.share,
    'icon': Icons.share,
  },
  {
    'text': 'Save note',
    'action': MenuItem.save,
    'icon': Icons.save_rounded,
  }
];
