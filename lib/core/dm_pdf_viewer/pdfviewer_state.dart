part of 'pdfviewer_cubit.dart';

abstract class GotitPdfViewerState extends Equatable {
  const GotitPdfViewerState();

  @override
  List<Object> get props => [];
}

class GotitPdfViewerInitialState extends GotitPdfViewerState {}

class GotitPdfViewerError extends GotitPdfViewerState {
  final String error;
  const GotitPdfViewerError(this.error);
}

class GotitPdfViewerPageChange extends GotitPdfViewerState {
  final int page;
  final int total;
  const GotitPdfViewerPageChange(this.page, this.total);
  @override
  List<Object> get props => [DateTime.now()];
}

class GotitPdfViewerPdfLoaded extends GotitPdfViewerState {
  final String path;
  const GotitPdfViewerPdfLoaded(this.path);
  @override
  List<Object> get props => [DateTime.now()];
}
