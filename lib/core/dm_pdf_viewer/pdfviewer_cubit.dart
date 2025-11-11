import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pdfviewer_state.dart';

class DMPdfViewerCubit extends Cubit<GotitPdfViewerState> {
  DMPdfViewerCubit() : super(GotitPdfViewerInitialState());
  void initPdfLocal(String localFilePath) async {
    emit(GotitPdfViewerInitialState());

    try {
      final file = File(localFilePath);
      // Wait until the file exists with a timeout
      bool fileExists = await _waitForFile(file);
      if (fileExists) {
        await Future.delayed(const Duration(milliseconds: 500));
        emit(GotitPdfViewerPdfLoaded(localFilePath));
      } else {
        emit(const GotitPdfViewerError("יש לנסות שוב עם חיבור לאינטרנט"));
      }
    } catch (e) {
      emit(GotitPdfViewerError(e.toString()));
    }
  }

  // Helper method to wait until file exists, with a timeout
  Future<bool> _waitForFile(File file,
      {Duration timeout = const Duration(seconds: 10)}) async {
    const interval = Duration(milliseconds: 200);
    final completer = Completer<bool>();

    Timer.periodic(interval, (timer) async {
      if (await file.exists()) {
        timer.cancel();
        completer.complete(true);
      }
    });

    // Timeout handling
    return completer.future.timeout(timeout, onTimeout: () => false);
  }

  void updateCurrentPage(int? page, int? total) {
    emit(GotitPdfViewerPageChange(page!, total!));
  }
}
