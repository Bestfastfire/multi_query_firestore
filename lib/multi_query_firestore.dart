library multi_query_firestore;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

enum _method {
  endAt,
  endAtDocument,
  endBefore,
  endBeforeDocument,
  limit,
  orderBy,
  startAfter,
  startAfterDocument,
  startAt,
  startAtDocument,
  limitToLast,
  where
}

class MultiQueryFirestore implements Query {
  final _mainS = BehaviorSubject<QuerySnapshot>();
  Map<int, List<DocumentChange>> _docsChanges = {};
  Map<int, List<DocumentSnapshot>> _docs = {};
  Map<int, StreamSubscription> _values = {};
  bool hasStarted = false;
  final List<Query> list;

  MultiQueryFirestore({@required this.list});

  _initListening() {
    if (!hasStarted) {
      for (int i = 0; i < list.length; i++) {
        final q = list[i];

        _values[i] = q.snapshots().listen((event) {
          _docsChanges[i] = event.docChanges;
          _docs[i] = event.docs;
          _update();
        });
      }
    }
  }

  _update() => _mainS.sink.add(MultiSnapshot(
      docsChanges: _docsChanges.values.toList(),
      docsList: _docs.values.toList()));

  List<int> _listSize([int i = 0]) => list.map<int>((e) => i++).toList();

  @required
  dispose() {
    _values.forEach((key, value) {
      value.cancel();
    });

    _mainS.close();
  }

  @override
  Stream<QuerySnapshot> snapshots({includeMetadataChanges = false}) {
    _initListening();
    return _mainS.stream;
  }

  @override
  Future<QuerySnapshot> getDocuments([GetOptions options]) => _get(options);

  @override
  Future<QuerySnapshot> get([GetOptions options]) => _get(options);

  Future<QuerySnapshot> _get([GetOptions options]) async {
    for (int i = 0; i < list.length; i++) {
      final v = await list[i].get(options);
      _docsChanges[i] = v.docChanges;
      _docs[i] = v.docs;
    }

    return MultiSnapshot(
        docsChanges: _docsChanges.values.toList(),
        docsList: _docs.values.toList());
  }

  @override
  Query endAt(List values) {
    _toOnly(type: _method.endAt, value: values);
    return this;
  }

  Query endAtOnly({@required List values, @required List<int> indexes}) {
    _toOnly(type: _method.endAt, indexes: indexes, value: values);
    return this;
  }

  @override
  Query endAtDocument(DocumentSnapshot documentSnapshot) {
    _toOnly(type: _method.endAtDocument, value: documentSnapshot);
    return this;
  }

  Query endAtDocumentOnly(
      {@required DocumentSnapshot documentSnapshot,
      @required List<int> indexes}) {
    _toOnly(value: documentSnapshot, type: _method.endAt, indexes: indexes);
    return this;
  }

  @override
  Query endBefore(List values) {
    _toOnly(type: _method.endBefore, value: values);
    return this;
  }

  Query endBeforeOnly({@required List<int> indexes, @required List values}) {
    _toOnly(type: _method.endBefore, indexes: indexes, value: values);
    return this;
  }

  @override
  Query endBeforeDocument(DocumentSnapshot documentSnapshot) {
    _toOnly(type: _method.endBeforeDocument, value: documentSnapshot);
    return this;
  }

  Query endBeforeDocumentOnly(
      {@required DocumentSnapshot documentSnapshot,
      @required List<int> indexes}) {
    _toOnly(
        type: _method.endBeforeDocument,
        value: documentSnapshot,
        indexes: indexes);
    return this;
  }

  @override
  Query limit(int length) {
    _toOnly(type: _method.limit, value: length);
    return this;
  }

  Query limitOnly({@required int length, @required List<int> indexes}) {
    _toOnly(type: _method.limit, indexes: indexes, value: length);
    return this;
  }

  @override
  Query orderBy(field, {bool descending = false}) {
    _toOnly(type: _method.orderBy, descending: descending);
    return this;
  }

  Query orderByOnly(
      {@required field, @required List<int> indexes, bool descending = false}) {
    _toOnly(descending: descending, type: _method.orderBy, indexes: indexes);
    return this;
  }

  @override
  Query startAfter(List values) {
    _toOnly(type: _method.startAfter, value: values);
    return this;
  }

  Query startAfterOnly({@required List values, @required List<int> indexes}) {
    _toOnly(type: _method.startAfter, indexes: indexes, value: values);
    return this;
  }

  @override
  Query startAfterDocument(DocumentSnapshot documentSnapshot) {
    _toOnly(type: _method.startAfterDocument, value: documentSnapshot);
    return this;
  }

  Query startAfterDocumentOnly(
      {@required DocumentSnapshot documentSnapshot,
      @required List<int> indexes}) {
    _toOnly(
        type: _method.startAfterDocument,
        value: documentSnapshot,
        indexes: indexes);
    return this;
  }

  @override
  Query startAt(List values) {
    _toOnly(type: _method.startAt, value: values);
    return this;
  }

  Query startAtOnly({@required List values, @required List<int> indexes}) {
    _toOnly(type: _method.startAt, indexes: indexes, value: values);
    return this;
  }

  @override
  Query startAtDocument(DocumentSnapshot documentSnapshot) {
    _toOnly(type: _method.startAtDocument, value: documentSnapshot);
    return this;
  }

  Query startAtDocumentOnly(
      {@required DocumentSnapshot documentSnapshot,
      @required List<int> indexes}) {
    _toOnly(
        type: _method.startAtDocument,
        value: documentSnapshot,
        indexes: indexes);
    return this;
  }

  @override
  Query limitToLast(int limit) {
    _toOnly(type: _method.limitToLast, value: limit);
    return this;
  }

  Query limitToLastOnly({@required int limit, @required List<int> indexes}) {
    _toOnly(type: _method.limitToLast, indexes: indexes, value: limit);
    return this;
  }

  @override
  Query where(dynamic field,
      {dynamic isEqualTo,
      dynamic isLessThan,
      dynamic isLessThanOrEqualTo,
      dynamic isGreaterThan,
      dynamic isGreaterThanOrEqualTo,
      dynamic arrayContains,
      List<dynamic> arrayContainsAny,
      List<dynamic> whereIn,
      bool isNull}) {
    _toOnly(
        type: _method.where,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        arrayContainsAny: arrayContainsAny,
        isGreaterThan: isGreaterThan,
        arrayContains: arrayContains,
        isLessThan: isLessThan,
        isEqualTo: isEqualTo,
        whereIn: whereIn,
        isNull: isNull);
    return this;
  }

  Query whereOnly(
      {@required dynamic field,
      @required List<int> indexes,
      dynamic isEqualTo,
      dynamic isLessThan,
      dynamic isLessThanOrEqualTo,
      dynamic isGreaterThan,
      dynamic isGreaterThanOrEqualTo,
      dynamic arrayContains,
      List<dynamic> arrayContainsAny,
      List<dynamic> whereIn,
      bool isNull}) {
    _toOnly(
        type: _method.where,
        indexes: indexes,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        arrayContainsAny: arrayContainsAny,
        isGreaterThan: isGreaterThan,
        arrayContains: arrayContains,
        isLessThan: isLessThan,
        isEqualTo: isEqualTo,
        whereIn: whereIn,
        isNull: isNull);
    return this;
  }

  Query _toOnly(
      {List<int> indexes,
      @required _method type,
      bool descending = false,
      dynamic value,
      dynamic isEqualTo,
      dynamic isLessThan,
      dynamic isLessThanOrEqualTo,
      dynamic isGreaterThan,
      dynamic isGreaterThanOrEqualTo,
      dynamic arrayContains,
      List<dynamic> arrayContainsAny,
      List<dynamic> whereIn,
      bool isNull}) {
    (indexes ?? _listSize()).forEach((i) {
      switch (type) {
        case _method.endAt:
          list[i] = list[i].endAt(value);
          break;

        case _method.endAtDocument:
          list[i] = list[i].endAtDocument(value);
          break;

        case _method.endBefore:
          list[i] = list[i].endBefore(value);
          break;

        case _method.endBeforeDocument:
          list[i] = list[i].endBeforeDocument(value);
          break;

        case _method.limit:
          list[i] = list[i].limit(value);
          break;

        case _method.orderBy:
          list[i] = list[i].orderBy(value, descending: descending);
          break;

        case _method.startAfter:
          list[i] = list[i].startAfter(value);
          break;

        case _method.startAfterDocument:
          list[i] = list[i].startAfterDocument(value);
          break;

        case _method.startAt:
          list[i] = list[i].startAt(value);
          break;

        case _method.startAtDocument:
          list[i] = list[i].startAtDocument(value);
          break;

        case _method.where:
          list[i] = list[i].where(value,
              isEqualTo: isEqualTo,
              isLessThan: isLessThan,
              isLessThanOrEqualTo: isLessThanOrEqualTo,
              isGreaterThan: isGreaterThan,
              isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
              arrayContains: arrayContains,
              arrayContainsAny: arrayContainsAny,
              whereIn: whereIn,
              isNull: isNull);
          break;

        case _method.limitToLast:
          list[i] = list[i].limitToLast(value);
          break;
      }
    });

    return this;
  }

  @override
  Map<String, dynamic> get parameters => parametersOf(0);

  Map<String, dynamic> parametersOf(int index) => this.list[index].parameters;

  @override
  FirebaseFirestore get firestore => this.firestore;
}

class MultiSnapshot implements QuerySnapshot {
  final List<List<DocumentChange>> docsChanges;
  final List<List<QueryDocumentSnapshot>> docsList;

  const MultiSnapshot({@required this.docsChanges, @required this.docsList});

  @override
  List<DocumentChange> get documentChanges =>
      docsChanges.fold<List<DocumentChange>>([], (c, e) {
        c.addAll(e);
        return c;
      }).toList();

  @override
  List<QueryDocumentSnapshot> get docs =>
      docsList.fold<List<QueryDocumentSnapshot>>([], (c, e) {
        c.addAll(e);
        return c;
      }).toList();

  @override
  SnapshotMetadata get metadata =>
      (docsList.length > 0 && docsList[0].length > 0)
          ? docsList[0][0].metadata
          : null;

  @override
  List<DocumentChange> get docChanges =>
      docsChanges.fold<List<DocumentChange>>([], (c, e) {
        c.addAll(e);
        return c;
      }).toList();

  @override
  int get size => docs.length;

  @override
  List<QueryDocumentSnapshot> get documents => docs;
}
