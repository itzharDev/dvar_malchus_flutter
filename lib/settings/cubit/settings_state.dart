part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class ChangeLocation extends SettingsState {
  @override
  List<Object> get props => [DateTime.now()];
}

class LocationChanged extends SettingsState {
  String location;
  LocationChanged({
    required this.location,
  });
  @override
  List<Object> get props => [DateTime.now()];
}

class ShowTanyaWithBiurChanged extends SettingsState {
  bool showTanyaWithBiur;
  ShowTanyaWithBiurChanged({
    required this.showTanyaWithBiur,
  });
  @override
  List<Object> get props => [DateTime.now()];
}

class UseExternalPdfViewerChanged extends SettingsState {
  bool useExternalPdfViewer;
  UseExternalPdfViewerChanged({
    required this.useExternalPdfViewer,
  });
  @override
  List<Object> get props => [DateTime.now()];
}
