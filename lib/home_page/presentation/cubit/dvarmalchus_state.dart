part of 'dvarmalchus_cubit.dart';

abstract class DvarmalchusState extends Equatable {
  const DvarmalchusState();

  @override
  List<Object> get props => [];
}

class DvarmalchusInitial extends DvarmalchusState {
  @override
  List<Object> get props => [DateTime.now()];
}

class DvarmalchusNoInternet extends DvarmalchusState {
  @override
  List<Object> get props => [DateTime.now()];
}

class PlayerStart extends DvarmalchusState {
  String subject;
  PlayerStart({
    required this.subject,
  });
  @override
  List<Object> get props => [DateTime.now()];
}

class PlayerStop extends DvarmalchusState {
  @override
  List<Object> get props => [DateTime.now()];
}

class PlayerInit extends DvarmalchusState {
  String subject;
  PlayerInit({
    required this.subject,
  });
  @override
  List<Object> get props => [DateTime.now()];
}

class HashlamotChanged extends DvarmalchusState {
  @override
  List<Object> get props => [DateTime.now()];
}

class ChooseRegion extends DvarmalchusState {
  @override
  List<Object> get props => [DateTime.now()];
}

class NoContentFound extends DvarmalchusState {
  @override
  List<Object> get props => [DateTime.now()];
}

class DvarMalchusDownloadProgress extends DvarmalchusState {
  final double progress;
  int completedDownloads;
  int totalDownloads;
  DvarMalchusDownloadProgress(
      this.progress, this.completedDownloads, this.totalDownloads);
  @override
  List<Object> get props => [progress, DateTime.now()];
}

class DvarmalchusReady extends DvarmalchusState {
  Dvarmalchus dvarmalchus;
  List<Map<String, dynamic>> subjects;
  DvarMalchusConfig config;
  dynamic hashlamot;
  dynamic comments;
  DateTime selectedDate;
  String hebrewDate;
  bool? noDataFound = false;
  DateTime firstDateOfWeek;
  int? random;
  DvarmalchusReady(
      this.selectedDate,
      this.dvarmalchus,
      this.subjects,
      this.config,
      this.hashlamot,
      this.comments,
      this.hebrewDate,
      this.firstDateOfWeek,
      {this.noDataFound,
      this.random});
  @override
  List<Object> get props => [
        {random},
        DateTime.now()
      ];
}

class DvarmalchusConfigReady extends DvarmalchusState {
  DvarMalchusConfig config;
  DvarmalchusConfigReady(this.config);
}
