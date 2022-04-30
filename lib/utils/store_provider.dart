import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/utils/magic_strings.dart';

final prefsProvider = FutureProvider<SharedPreferences>(
    (ref) async => await SharedPreferences.getInstance());

var storeProvider = StateNotifierProvider<StoreProvider, String>((ref) {
  return StoreProvider(ref
      .watch(prefsProvider)
      .maybeWhen(data: ((data) => data), orElse: () => null));
});

class StoreProvider extends StateNotifier<String> {
  final SharedPreferences? prefs;
  StoreProvider(this.prefs)
      : super(prefs?.getString(SharedPreferencesNames.selectedStore) ?? 'col');

  updateStore(String storeName) async {
    this.state = storeName;
    print('supermarket: ${this.state}');
    await prefs?.setString(SharedPreferencesNames.selectedStore, storeName);
  }
}
