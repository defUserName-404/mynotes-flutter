import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'cloud_storage_constants.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String title;
  final String content;
  final int color;
  final bool isFavorite;

  const CloudNote(
      {required this.documentId,
      required this.ownerUserId,
      required this.title,
      required this.content,
      required this.color,
      required this.isFavorite});

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        title = snapshot.data()[titleFieldName],
        content = snapshot.data()[contentFieldName],
        color = snapshot.data()[colorFieldName],
        isFavorite = snapshot.data()[isFavoriteFieldName];
}
