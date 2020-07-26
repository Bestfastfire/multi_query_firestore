library multi_query_firestore;

import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart'
    as platform;
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
          _docsChanges[i] = event.documentChanges;
          _docs[i] = event.documents;
          _update();
        });
      }
    }
  }

  _update() => _mainS.sink.add(MultiSnapshot(
      docsChanges: _docsChanges.values.toList(), docs: _docs.values.toList()));

  List<int> _listSize([int i = 0]) => list.map<int>((e) => i++).toList();

  @override
  Stream<QuerySnapshot> snapshots({includeMetadataChanges = false}) {
    _initListening();
    return _mainS.stream;
  }

  @override
  Future<QuerySnapshot> getDocuments({
    platform.Source source = platform.Source.serverAndCache,
  }) =>
      _getDocuments();

  Future<QuerySnapshot> _getDocuments({
    platform.Source source = platform.Source.serverAndCache,
  }) async {
    for (int i = 0; i < list.length; i++) {
      final v = await list[i].getDocuments(source: source);
      _docsChanges[i] = v.documentChanges;
      _docs[i] = v.documents;
    }

    return MultiSnapshot(
        docsChanges: _docsChanges.values.toList(), docs: _docs.values.toList());
  }

  @required
  dispose() {
    _values.forEach((key, value) {
      value.cancel();
    });

    _mainS.close();
  }

  @override
  Map<String, dynamic> buildArguments() {
    throw UnimplementedError();
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
  Firestore get firestore => this.firestore;

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
  CollectionReference reference() {
    throw UnimplementedError();
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
      }
    });

    return this;
  }
}

class MultiSnapshot implements QuerySnapshot {
  final List<List<DocumentChange>> docsChanges;
  final List<List<DocumentSnapshot>> docs;

  const MultiSnapshot({@required this.docsChanges, @required this.docs});

  @override
  List<DocumentChange> get documentChanges =>
      docsChanges.fold<List<DocumentChange>>([], (c, e) {
        c.addAll(e);
        return c;
      }).toList();

  @override
  List<DocumentSnapshot> get documents =>
      docs.fold<List<DocumentSnapshot>>([], (c, e) {
        c.addAll(e);
        return c;
      }).toList();

  @override
  SnapshotMetadata get metadata => throw UnimplementedError();
}
