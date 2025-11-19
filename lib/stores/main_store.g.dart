// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MainStore on _MainStore, Store {
  late final _$initializeAsyncAction = AsyncAction(
    '_MainStore.initialize',
    context: context,
  );

  @override
  Future<void> initialize() {
    return _$initializeAsyncAction.run(() => super.initialize());
  }

  late final _$_initializeSampleDataIfNeededAsyncAction = AsyncAction(
    '_MainStore._initializeSampleDataIfNeeded',
    context: context,
  );

  @override
  Future<void> _initializeSampleDataIfNeeded() {
    return _$_initializeSampleDataIfNeededAsyncAction.run(
      () => super._initializeSampleDataIfNeeded(),
    );
  }

  late final _$_MainStoreActionController = ActionController(
    name: '_MainStore',
    context: context,
  );

  @override
  void _onAuthStateChanged(bool isLoggedIn) {
    final _$actionInfo = _$_MainStoreActionController.startAction(
      name: '_MainStore._onAuthStateChanged',
    );
    try {
      return super._onAuthStateChanged(isLoggedIn);
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
