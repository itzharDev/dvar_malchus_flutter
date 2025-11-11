import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dvarmalchus_flutter/core/ioc.dart';
import 'package:dvarmalchus_flutter/home_page/presentation/cubit/dvarmalchus_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SharedPreferences? prefs;
  SettingsCubit() : super(SettingsInitial());

  void init() async {
    prefs = await SharedPreferences.getInstance();
    var country = prefs!.getString('country');
    emit(LocationChanged(location: country!));
    var showTanyaWithBiur = prefs!.getBool('showTanyaWithBiur');
    if (showTanyaWithBiur == null) {
      this.showTanyaWithBiur(true);
    } else {
      emit(ShowTanyaWithBiurChanged(showTanyaWithBiur: showTanyaWithBiur));
    }
    var useExternalPdfViewer = prefs!.getBool('useExternalPdfViewer');
    if (useExternalPdfViewer == null) {
      setUseExternalPdfViewer(false);
    } else {
      emit(UseExternalPdfViewerChanged(useExternalPdfViewer: useExternalPdfViewer));
    }
  }

  void changeLocation() {
    emit(ChangeLocation());
  }

  void setCountry(String country) async {
    await prefs?.setString('country', country);
    emit(LocationChanged(location: country));
  }

  void showTanyaWithBiur(bool showTanyaWithBiur) async {
    await prefs?.setBool('showTanyaWithBiur', showTanyaWithBiur);
    emit(ShowTanyaWithBiurChanged(showTanyaWithBiur: showTanyaWithBiur));
    locator.get<DvarmalchusCubit>().emitChanges();
  }

  bool readTanyaWithBiur() {
    return prefs?.getBool('showTanyaWithBiur') ?? false;
  }

  void setUseExternalPdfViewer(bool useExternalPdfViewer) async {
    await prefs?.setBool('useExternalPdfViewer', useExternalPdfViewer);
    emit(UseExternalPdfViewerChanged(useExternalPdfViewer: useExternalPdfViewer));
  }

  bool readUseExternalPdfViewer() {
    return prefs?.getBool('useExternalPdfViewer') ?? false;
  }

  Future<void> clearDocumentsDirectory() async {
    // Get the application documents directory.
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    // List all items (files & directories) in the directory.
    final List<FileSystemEntity> files = appDocDir.listSync();

    // Delete each item recursively.
    for (final file in files) {
      try {
        await file.delete(recursive: true);
      } catch (e) {
        print('Error deleting ${file.path}: $e');
      }
    }
    locator.get<DvarmalchusCubit>().init();
  }
}
