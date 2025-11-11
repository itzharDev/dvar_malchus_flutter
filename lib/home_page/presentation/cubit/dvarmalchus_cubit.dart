import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kosher_dart/kosher_dart.dart';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dvarmalchus_flutter/core/ioc.dart';
import 'package:dvarmalchus_flutter/core/network/response/config.dart';
import 'package:dvarmalchus_flutter/core/network/response/dvarmalchus.dart';
import 'package:dvarmalchus_flutter/core/rest_client.dart';
import 'package:dvarmalchus_flutter/settings/cubit/settings_cubit.dart';

part 'dvarmalchus_state.dart';

class _DownloadTask {
  final String url;
  final String fileName;
  final String subjectIndex;

  _DownloadTask({
    required this.url,
    required this.fileName,
    required this.subjectIndex,
  });
}

// Define your default subjects list as a constant
const List<Map<String, dynamic>> defaultSubjects = [
  {"title": 'דבר מלכות'},
  {"title": 'חומש יומי'},
  {"title": 'תהילים'},
  {"title": 'תניא יומי'},
  {"title": 'היום יום'},
  {"title": 'רמב"ם 3 פרקים'},
  {"title": 'רמב"ם פרק 1'},
  {"title": 'ספר המצוות'},
];

class DvarmalchusCubit extends Cubit<DvarmalchusState> {
  final RestClient restClient;
  DvarMalchusConfig? config;
  Dvarmalchus? dvarmalchus;
  Map<dynamic, dynamic> hashlamot = {};
  Map<dynamic, dynamic> comments = {};
  var currentDate = DateTime.now();
  var selectedDate = DateTime.now();
  JewishDate jewishDate = JewishDate();
  HebrewDateFormatter hebrewDateFormatter = HebrewDateFormatter();
  String hebrewDate = '';
  DateTime? firstDateOfWeek;
  SharedPreferences? prefs;
  AudioPlayer player = AudioPlayer();
  List<Map<String, dynamic>> subjects = defaultSubjects
      .asMap()
      .entries
      .map((entry) => {
            "id": entry.key, // This gives each item a unique numeric id
            ...entry.value,
          })
      .toList();
  String? filesBasePath;

  DvarmalchusCubit(this.restClient) : super(DvarmalchusInitial());

  void init() async {
    // await clearDocumentsDirectory();
    prefs = await SharedPreferences.getInstance();
    // var a = await prefs?.clear();
    // print('a: $a');
    var country = prefs?.getString('country');
    // emit(DvarmalchusConfigReady(config!));
    hebrewDateFormatter.hebrewFormat = true; // optional
    hebrewDateFormatter.useGershGershayim = true; // optional
    hebrewDate = hebrewDateFormatter.format(jewishDate);
    firstDateOfWeek = findFirstDateOfTheWeek(selectedDate);
    await loadSubjects();
    initHashlamot();
    initComments();
    final Directory dir = await getApplicationDocumentsDirectory();
    filesBasePath = dir.path;
    if (country != null) {
      try {
        config ??= await restClient.getConfig();
      } on Exception {
        config ??=
            DvarMalchusConfig.fromJson(jsonDecode(prefs!.getString('config')!));
      }
      final configJsonString = jsonEncode(config!.toJson());
      prefs!.setString('config', configJsonString);
      getDvarMalchus();
    } else {
      emit(ChooseRegion());
    }
  }

  // Load stored subjects from local storage.
// If none is found, use the default subjects list.
  Future<void> loadSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final String? subjectsJson = prefs.getString('subjects');
    if (subjectsJson != null) {
      try {
        List<dynamic> jsonList = jsonDecode(subjectsJson);
        subjects = jsonList
            .map<Map<String, dynamic>>(
                (item) => Map<String, dynamic>.from(item as Map))
            .toList();
      } catch (e) {
        // If decoding fails, use the default list.
        subjects = List.from(defaultSubjects);
        saveSubjects();
      }
    } else {
      // First run: use default list and save it.
      subjects = List.from(defaultSubjects);
      saveSubjects();
    }
  }

// Save the subjects list to local storage.
  Future<void> saveSubjects() async {
    // Only keep the 'title' key for each subject before saving
    final subjectsToSave =
        subjects.map((subject) => {'title': subject['title']}).toList();
    final prefs = await SharedPreferences.getInstance();
    final String subjectsJson = jsonEncode(subjectsToSave);
    await prefs.setString('subjects', subjectsJson);
  }

  // Save the subjects list to local storage.
  Future<void> deleteSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('subjects');
  }

  void initHashlamot() {
    var hashlamotStr =
        prefs!.getString(firstDateOfWeek!.toIso8601String().split('T')[0]);
    if (hashlamotStr == null || hashlamotStr.isEmpty) {
      var newKey = firstDateOfWeek!.toIso8601String().split('T')[0].toString();
      hashlamot.addAll({newKey: {}});
    } else {
      var hashlamotDecoded = json.decode(hashlamotStr);
      var newKey = firstDateOfWeek!.toIso8601String().split('T')[0].toString();
      hashlamot.addAll({newKey: hashlamotDecoded});
    }
  }

  void initComments() {
    var commentsStr = prefs!.getString(
        'comment-${firstDateOfWeek!.toIso8601String().split('T')[0]}');
    if (commentsStr == null || commentsStr.isEmpty) {
      var newKey = firstDateOfWeek!.toIso8601String().split('T')[0].toString();
      comments.addAll({newKey: {}});
    } else {
      var commentsDecoded = json.decode(commentsStr);
      var newKey = firstDateOfWeek!.toIso8601String().split('T')[0].toString();
      comments.addAll({newKey: commentsDecoded});
    }
  }

  void getDvarMalchus() async {
    var country = prefs?.getString('country');
    if (country == null || country.isEmpty) {
      country = 'il';
    }
    try {
      var allContent = prefs?.getString('all');
      var local = getLocalDm(firstDateOfWeek!);
      if (local == null) {
        try {
          dvarmalchus = await restClient.getDvarMalchus({
            "date": firstDateOfWeek!.toIso8601String(),
            'country': country,
          });
        } on Exception {
          emit(DvarmalchusNoInternet());
        }
        prefs?.setString(firstDateOfWeek!.toIso8601String(),
            jsonEncode(dvarmalchus!.toJson()));
      } else {
        dvarmalchus = local;
      }
    } on RangeError {
      emit(NoContentFound());
      return;
    }

    var currentDayIndex = getCurrentDayIndex(selectedDate);
    for (var extra in dvarmalchus?.extras ?? []) {
      // Build the new item.
      final newItem = {
        "title": extra.subject,
        "text_color": extra.text_color,
      };

      if (extra.arr != null && extra.arr!.isNotEmpty) {
        // Build a urlMap for each day
        final Map<int, String> urlMap = {};
        for (int i = 0; i < extra.arr!.length; i++) {
          urlMap[i + 1] = extra.arr![i];
        }
        newItem['urlMap'] = urlMap;
      } else if (extra.url != null && extra.url!.isNotEmpty) {
        newItem['url'] = extra.url!;
      }

      final existingIndex = subjects.indexWhere(
        (item) => item["title"] == extra.subject,
      );

      if (existingIndex >= 0) {
        // If the subject already exists, update it only if it is enabled.
        if (subjects[existingIndex]["enabled"] == true) {
          subjects.removeAt(existingIndex);
          subjects.insert(existingIndex, newItem);
          // Ensure the "enabled" flag remains true.
          subjects[existingIndex]["enabled"] = true;
        } else {
          //BOBO comment make sure my edit is ok - should u remove it here?
          // subjects.removeAt(existingIndex);
        }
        // If the subject exists but is disabled, leave it unchanged.
      } else {
        // For new items, default to enabled.
        newItem["enabled"] = true;
        var position = int.tryParse(extra.position) ?? subjects.length;
        var safePosition = position.clamp(0, subjects.length);
        subjects.insert(safePosition, newItem);
      }
    }
    // Filter to include only enabled subjects.
    var filteredSubjects = subjects
        .where((subject) =>
            !subject.containsKey('enabled') || subject['enabled'] == true)
        .toList();

    var filteredSubjects2 =
        subjects.where((subject) => subject['enabled'] == true).toList();

    if (filteredSubjects.length > filteredSubjects2.length) {
      //new subject from extras
      saveSubjects();
    }

    var finalState = prepareSubjectsUrlsAndRecords(DvarmalchusReady(
        currentDate,
        dvarmalchus!,
        filteredSubjects,
        config!,
        hashlamot,
        comments,
        hebrewDate,
        firstDateOfWeek!));
    // Calculate Sunday of the current week (Dart's DateTime.weekday: 1 = Monday, 7 = Sunday)
    final int daysSinceSunday = currentDate.weekday % 7;
    final startOfWeek = currentDate.subtract(Duration(days: daysSinceSunday));

    // Build the list of formatted dates for the week.
    List<String> weekDates = List.generate(7, (i) {
      final day = startOfWeek.add(Duration(days: i));
      return DateFormat('ddMMyyyy', 'en').format(day);
    });

    // Now call your download function with a progress callback.
    downloadAllPdfs(
      finalState.subjects,
      weekDates,
    );
    emit(finalState);
  }

  DvarmalchusReady prepareSubjectsUrlsAndRecords(DvarmalchusReady state) {
    // Convert subjects to new mutable maps.
    state.subjects = state.subjects
        .map((subject) => Map<String, dynamic>.from(subject))
        .toList();

    for (var subject in state.subjects) {
      switch (subject['title']) {
        case 'דבר מלכות':
          // Static content – same for all days.
          subject['record'] = state.dvarmalchus.records.getDvarMalchus();
          subject['url'] = state.dvarmalchus.content.getDvarMalchus();
          break;
        case 'חומש יומי':
          _setDayDependentContent(
            subject,
            (day) => state.dvarmalchus.records.getChumash(day),
            (day) => state.dvarmalchus.content.getChumash(day),
          );
          break;
        case 'תהילים':
          _setDayDependentContent(
            subject,
            (day) => state.dvarmalchus.records.getTehilim(day),
            (day) => state.dvarmalchus.content.getTehilim(day),
          );
          break;
        case 'תניא יומי':
          _setDayDependentContent(
            subject,
            (day) => state.dvarmalchus.records.getTanya(day),
            (day) {
              String url = state.dvarmalchus.content.getTanya(day);
              // Adjust URL if biur should not be read.
              if (!locator.get<SettingsCubit>().readTanyaWithBiur()) {
                url = url.contains("meuberet")
                    ? url.replaceAll("meuberet", "meuberetNoBiur")
                    : url.replaceAll("regular", "regularNoBiur");
              }
              return url;
            },
          );
          break;
        case 'היום יום':
          _setDayDependentContent(
            subject,
            (day) => state.dvarmalchus.records.getYomyom(day),
            (day) => state.dvarmalchus.content.getYomyom(day),
          );
          break;
        case 'רמב"ם 3 פרקים':
          _setDayDependentContent(
            subject,
            (day) => state.dvarmalchus.records.getRambamThree(day),
            (day) => state.dvarmalchus.content.getRambamThree(day),
          );
          break;
        case 'רמב"ם פרק 1':
          _setDayDependentContent(
            subject,
            (day) => state.dvarmalchus.records.getRambamOne(day),
            (day) => state.dvarmalchus.content.getRambamOne(day),
          );
          break;
        case 'ספר המצוות':
          _setDayDependentContent(
            subject,
            (day) => state.dvarmalchus.records.getSeferM(day),
            (day) => state.dvarmalchus.content.getSeferM(day),
          );
          break;
      }
      // For extras with urlMap but no recordMap, set an empty recordMap
      if (subject.containsKey('urlMap') && !subject.containsKey('recordMap')) {
        subject['recordMap'] = {};
      }
    }
    return state;
  }

  /// Helper function to set day-dependent content for a subject.
  /// It builds two maps for days 1–7:
  ///   - 'recordMap' with each day's record
  ///   - 'urlMap' with each day's URL
  void _setDayDependentContent(
    Map<String, dynamic> subject,
    dynamic Function(int day) recordGetter,
    String Function(int day) urlGetter,
  ) {
    final Map<int, dynamic> recordMap = {};
    final Map<int, String> urlMap = {};

    for (int day = 1; day <= 7; day++) {
      recordMap[day] = recordGetter(day);
      urlMap[day] = urlGetter(day);
    }
    subject['recordMap'] = recordMap;
    subject['urlMap'] = urlMap;
  }

  Future<void> downloadAllPdfs(
      List<Map<String, dynamic>> subjects, List<String> subjectIndexes) async {
    // Prepare a list of download tasks for files that do NOT exist.
    final List<_DownloadTask> tasks = [];

    for (final subject in subjects) {
      final String title = subject['title'];

      // Find the matching extra if it exists
      final extra = dvarmalchus?.extras.firstWhere(
        (e) => e.subject == title,
        orElse: () => Extra(
          subject: '',
          webSubject: '',
          position: '',
          text_color: '',
          type: '',
          arr: [],
          url: '',
        ),
      );
      final isWeekly = extra != null && extra.type == 'weekly';

      if (subject.containsKey('urlMap')) {
        if (isWeekly) {
          // For weekly extras, always use the first subjectIndex for download and access
          final String subjectIndex = subjectIndexes[0];
          final String? url = subject['urlMap'][1]; // Use the first day
          // Set all days in urlMap to the same url for consistency
          for (int day = 1; day <= 7; day++) {
            subject['urlMap'][day] = url;
          }
          if (url != null) {
            final String filePath = '$filesBasePath/$subjectIndex/$title';
            final File file = File(filePath);
            if (!await file.exists()) {
              final taskUrl = 'https://s3.amazonaws.com/DvarMalchus/$url';
              if (tasks.any((task) =>
                  task.url == taskUrl && task.subjectIndex == subjectIndex)) {
                // print(
                //     'Skipping download task for $taskUrl as it already exists.');
              } else {
                tasks.add(_DownloadTask(
                  url: taskUrl,
                  fileName: title,
                  subjectIndex: subjectIndex,
                ));
              }
            }
          }
        } else {
          // Use the day-specific URLs from urlMap.
          for (int i = 0; i < subjectIndexes.length; i++) {
            final String subjectIndex = subjectIndexes[i];
            final int dayIndex =
                i + 1; // assuming the first index corresponds to day 1
            final String? url = subject['urlMap'][dayIndex];
            if (url != null) {
              final String filePath = '$filesBasePath/$subjectIndex/$title';
              final File file = File(filePath);
              if (!await file.exists()) {
                final taskUrl = 'https://s3.amazonaws.com/DvarMalchus/$url';
                if (tasks.any((task) =>
                    task.url == taskUrl && task.subjectIndex == subjectIndex)) {
                  // print(
                  //     'Skipping download task for $taskUrl as it already exists.');
                } else {
                  tasks.add(_DownloadTask(
                    url: taskUrl,
                    fileName: title,
                    subjectIndex: subjectIndex,
                  ));
                }
              }
            }
          }
        }
      } else {
        // Fallback: use static URL if no urlMap is provided.
        final String url = subject['url'];
        for (final subjectIndex in subjectIndexes) {
          final String filePath = '$filesBasePath/$subjectIndex/$title';
          final File file = File(filePath);
          if (!await file.exists()) {
            final taskUrl = 'https://s3.amazonaws.com/DvarMalchus/$url';
            if (tasks.any((task) =>
                task.url == taskUrl && task.subjectIndex == subjectIndex)) {
              // print(
              //     'Skipping download task for $taskUrl as it already exists.');
            } else {
              tasks.add(_DownloadTask(
                url: taskUrl,
                fileName: title,
                subjectIndex: subjectIndex,
              ));
            }
          }
        }
      }
    }

    // Use only tasks that require downloading for progress calculation.
    final int totalDownloads = tasks.length;
    int completedDownloads = 0;

    // If there is nothing to download, emit 100% progress immediately.
    if (totalDownloads == 0) {
      emit(
          DvarMalchusDownloadProgress(1.0, completedDownloads, totalDownloads));
      return;
    }
    // print('Total downloads needed: $totalDownloads');
    // Process each download task.
    // Create a map to track downloaded files for weekly content.
    final Map<String, String> downloadedFiles = {};
    final Map<String, String> downloadedFilesBasePath = {};

    for (final task in tasks) {
      try {
        // Check if the file for this URL has already been downloaded for index 1.
        if (downloadedFiles.containsKey(task.url)) {
          // Copy the file from the index 1 location to the current subject index.
          final String sourceFilePath = downloadedFilesBasePath[task.url]!;
          final String destinationFilePath =
              '$filesBasePath/${task.subjectIndex}/${task.fileName}';
          final File sourceFile = File(sourceFilePath);
          final File destinationFile = File(destinationFilePath);

          // Ensure the directory exists.
          await destinationFile.parent.create(recursive: true);

          // Copy the file.
          await sourceFile.copy(destinationFilePath);
        } else {
          // Download and save the PDF for the first time.
          final bool isDownloaded = await downloadAndSavePdf(
              task.url, task.fileName, task.subjectIndex);

          // If the file was downloaded, store its path.
          if (isDownloaded) {
            downloadedFiles[task.url] = task.url;
            downloadedFilesBasePath[task.url] =
                '$filesBasePath/${task.subjectIndex}/${task.fileName}';
          }
        }
      } on Exception catch (e) {
        // Optionally handle exceptions (e.g., logging or retry mechanisms).
        print(
            'Error downloading ${task.fileName} for ${task.subjectIndex}: $e');
      } finally {
        completedDownloads++;
        // print('Completed downloads: $completedDownloads');
        emit(DvarMalchusDownloadProgress((completedDownloads / totalDownloads),
            completedDownloads, totalDownloads));
      }
    }
  }

  Future<bool> downloadAndSavePdf(
      String url, String fileName, String subjectIndex) async {
    final Dio dio = Dio();
    final Directory dir = await getApplicationDocumentsDirectory();
    final String filePath = '$filesBasePath/$subjectIndex/$fileName';

    // Check if file already exists.
    final File file = File(filePath);
    if (await file.exists()) {
      return true;
    }

    // Ensure the directory exists.
    await file.parent.create(recursive: true);

    // Download the PDF and save it.
    await dio.download(url, filePath);
    return true;
  }

  int getCurrentDayIndex(DateTime selectedDate) {
    var day =
        DateFormat('EEEE', 'he').format(selectedDate).replaceAll('יום ', '');
    switch (day) {
      case 'ראשון':
        return 1;
      case 'שני':
        return 2;
      case 'שלישי':
        return 3;
      case 'רביעי':
        return 4;
      case 'חמישי':
        return 5;
      case 'שישי':
        return 6;
      case 'שבת':
        return 7;
      default:
        return 1;
    }
  }

  Dvarmalchus? getLocalDm(DateTime fdow) {
    Dvarmalchus? local;
    var localDMByDate = prefs?.getString(fdow.toIso8601String());
    if (localDMByDate != null) {
      var decoded = json.decode(localDMByDate);
      local = Dvarmalchus.fromJson(decoded);
    }
    return local;
  }

  void readed(bool readed, Map<String, dynamic> hashlama,
      List<Map<String, dynamic>> subjects) {
    if (hashlamot[firstDateOfWeek!.toIso8601String().split('T')[0]] == null) {
      var newKey = firstDateOfWeek!.toIso8601String().split('T')[0].toString();
      hashlamot.addAll({newKey: {}});
    }
    hashlamot[firstDateOfWeek!.toIso8601String().split('T')[0]]![
        '${hashlama['subject']}-${hashlama['day']}'] = readed;
    prefs!
        .setString(
            firstDateOfWeek!.toIso8601String().split('T')[0],
            json.encode(
                hashlamot[firstDateOfWeek!.toIso8601String().split('T')[0]]))
        .then((value) => null);

    emit(DvarmalchusReady(selectedDate, dvarmalchus!, subjects, config!,
        hashlamot, comments, hebrewDate, firstDateOfWeek!));
  }

  void resetPrefs() {
    prefs!.remove(firstDateOfWeek!.toIso8601String().split('T')[0]).then(
      (value) {
        var filteredSubjects = subjects
            .where((subject) =>
                !subject.containsKey('enabled') || subject['enabled'] == true)
            .toList();
        emit(DvarmalchusReady(selectedDate, dvarmalchus!, filteredSubjects,
            config!, hashlamot, comments, hebrewDate, firstDateOfWeek!));
      },
    );
  }

  void comment(String commentText, Map<String, dynamic> comment,
      List<Map<String, dynamic>> subjects) {
    if (comments[firstDateOfWeek!.toIso8601String().split('T')[0]] == null) {
      var newKey = firstDateOfWeek!.toIso8601String().split('T')[0].toString();
      comments.addAll({newKey: {}});
    }
    comments[firstDateOfWeek!.toIso8601String().split('T')[0]]![
        '${comment['subject']}-${comment['day']}'] = commentText;
    prefs!
        .setString(
          'comment-${firstDateOfWeek!.toIso8601String().split('T')[0]}',
          json.encode(
            comments[firstDateOfWeek!.toIso8601String().split('T')[0]],
          ),
        )
        .then((value) => null);

    // Create a Random instance
    final random = Random();

// Define a maximum value for the random integer
    int maxValue = 100000; // for example, to generate a number between 0 and 99

// Then generate a random integer
    int randomInt = random.nextInt(maxValue);

    emit(DvarmalchusReady(selectedDate, dvarmalchus!, subjects, config!,
        hashlamot, comments, hebrewDate, firstDateOfWeek!,
        random: randomInt));
  }

  void changeDay(bool prevDay) async {
    var noDataFound = false;
    emit(DvarmalchusInitial());
    selectedDate = selectedDate.add(
      Duration(days: prevDay ? -1 : 1),
    );
    if (prevDay) {
      jewishDate.back();
    } else {
      jewishDate.forward();
    }

    var firstDateOfWeekTmp = findFirstDateOfTheWeek(selectedDate);
    hebrewDate = hebrewDateFormatter.format(jewishDate);
    if (firstDateOfWeek!.compareTo(firstDateOfWeekTmp) != 0) {
      try {
        var country = prefs?.getString('country');
        if (country == null || country.isEmpty) {
          country = 'il';
        }
        var local = getLocalDm(firstDateOfWeekTmp);
        if (local == null) {
          try {
            dvarmalchus = await restClient.getDvarMalchus(
                {"date": selectedDate.toIso8601String(), 'country': country});
          } on Exception {
            emit(DvarmalchusNoInternet());
            return;
          }
          firstDateOfWeek = firstDateOfWeekTmp;
          initHashlamot();
          initComments();
          prefs?.setString(firstDateOfWeek!.toIso8601String(),
              jsonEncode(dvarmalchus!.toJson()));
        } else {
          firstDateOfWeek = firstDateOfWeekTmp;
          initHashlamot();
          initComments();
          dvarmalchus = local;
        }
      } on RangeError {
        // no content for this date - revert date
        noDataFound = true;
        selectedDate = selectedDate.add(
          Duration(days: prevDay ? 1 : -1),
        );
        if (prevDay) {
          jewishDate.forward();
        } else {
          jewishDate.back();
        }
        hebrewDate = hebrewDateFormatter.format(jewishDate);
      }
    }
    var filteredSubjects = subjects
        .where((subject) =>
            !subject.containsKey('enabled') || subject['enabled'] == true)
        .toList();

    var finalState = prepareSubjectsUrlsAndRecords(DvarmalchusReady(
        selectedDate,
        dvarmalchus!,
        filteredSubjects,
        config!,
        hashlamot,
        comments,
        hebrewDate,
        firstDateOfWeek!,
        noDataFound: noDataFound));
    // Calculate Sunday of the current week (Dart's DateTime.weekday: 1 = Monday, 7 = Sunday)
    final int daysSinceSunday = selectedDate.weekday % 7;
    final startOfWeek = selectedDate.subtract(Duration(days: daysSinceSunday));

    // Build the list of formatted dates for the week.
    List<String> weekDates = List.generate(7, (i) {
      final day = startOfWeek.add(Duration(days: i));
      return DateFormat('ddMMyyyy', 'en').format(day);
    });

    // Now call your download function with a progress callback.
    downloadAllPdfs(
      finalState.subjects,
      weekDates,
    );
    emit(finalState);
  }

  void changeWeek(bool prevDay) async {
    var noDataFound = false;
    emit(DvarmalchusInitial());
    selectedDate = selectedDate.add(
      Duration(days: prevDay ? -7 : 7),
    );
    if (prevDay) {
      jewishDate.back();
      jewishDate.back();
      jewishDate.back();
      jewishDate.back();
      jewishDate.back();
      jewishDate.back();
      jewishDate.back();
    } else {
      jewishDate.forward();
      jewishDate.forward();
      jewishDate.forward();
      jewishDate.forward();
      jewishDate.forward();
      jewishDate.forward();
      jewishDate.forward();
    }

    var firstDateOfWeekTmp = findFirstDateOfTheWeek(selectedDate);
    hebrewDate = hebrewDateFormatter.format(jewishDate);
    if (firstDateOfWeek!.compareTo(firstDateOfWeekTmp) != 0) {
      try {
        var country = prefs?.getString('country');
        if (country == null || country.isEmpty) {
          country = 'il';
        }
        var local = getLocalDm(firstDateOfWeekTmp);
        if (local == null) {
          dvarmalchus = await restClient.getDvarMalchus(
              {"date": selectedDate.toIso8601String(), 'country': country});
          firstDateOfWeek = firstDateOfWeekTmp;
          initHashlamot();
          initComments();
          prefs?.setString(firstDateOfWeek!.toIso8601String(),
              jsonEncode(dvarmalchus!.toJson()));
        } else {
          firstDateOfWeek = firstDateOfWeekTmp;
          initHashlamot();
          initComments();
          dvarmalchus = local;
        }
      } on RangeError {
        // no content for this date - revert date
        noDataFound = true;
        selectedDate = selectedDate.add(
          Duration(days: prevDay ? 1 : -1),
        );
        if (prevDay) {
          jewishDate.forward();
        } else {
          jewishDate.back();
        }
        hebrewDate = hebrewDateFormatter.format(jewishDate);
      }
    }
    emit(DvarmalchusReady(selectedDate, dvarmalchus!, subjects, config!,
        hashlamot, comments, hebrewDate, firstDateOfWeek!,
        noDataFound: noDataFound));
  }

  void emitChanges() {
    emit(DvarmalchusReady(
      selectedDate,
      dvarmalchus!,
      subjects,
      config!,
      hashlamot,
      comments,
      hebrewDate,
      firstDateOfWeek!,
    ));
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    if (jewishDate.getDayOfWeek() == 1) {
      return dateTime.subtract(Duration(
          days: 0,
          hours: dateTime.hour,
          minutes: dateTime.minute,
          seconds: dateTime.second,
          milliseconds: dateTime.millisecond,
          microseconds: dateTime.microsecond));
    } else {
      return dateTime.subtract(Duration(
          days: dateTime.weekday,
          hours: dateTime.hour,
          minutes: dateTime.minute,
          seconds: dateTime.second,
          milliseconds: dateTime.millisecond,
          microseconds: dateTime.microsecond));
    }
  }

  void setCountry(String country) async {
    await prefs?.setString('country', country);
    emit(DvarmalchusInitial());
    config = await restClient.getConfig();
    getDvarMalchus();
  }

  void play(BuildContext context, String subject, String recordUrl) async {
    emit(PlayerInit(subject: subject));
    await player.stop();
    player.setUrl(recordUrl);
    // print('playing: $recordUrl');
    try {
      await player.play();
      emit(PlayerStart(subject: subject));
    } on Exception {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text(
            'שגיאה',
            textAlign: TextAlign.right,
          ),
          content: Text(
            'נראה שיש לנו בעיה עם ההקלטה',
            textAlign: TextAlign.right,
          ),
        ),
      );
    }
  }

  void stop() async {
    await player.stop();
    emit(PlayerStop());
  }

  void updateSubjectsPositions(int oldIndex, int newIndex,
      List<Map<String, dynamic>> filteredSubjects) async {
    final item = filteredSubjects.removeAt(oldIndex);
    // Insert the item into its new position.
    filteredSubjects.insert(newIndex, item);
    // Build a new list from scratch while keeping only one item per title.
    List<Map<String, dynamic>> uniqueSubjects = [];
    Set<String> seenTitles = {};

    for (var subject in filteredSubjects) {
      final title = subject['title'];
      if (!seenTitles.contains(title)) {
        seenTitles.add(title);
        uniqueSubjects.add(subject);
      }
    }

    // Replace subjects with the unique list.
    filteredSubjects = uniqueSubjects;
    // Create a map to quickly find the index from filteredSubjects
    final orderMap = {
      for (int i = 0; i < filteredSubjects.length; i++)
        filteredSubjects[i]['title']: i
    };

    // Sort subjects by index from filteredSubjects, otherwise keep them at the end
    subjects.sort((a, b) {
      int indexA = orderMap.containsKey(a['title'])
          ? orderMap[a['title']]!
          : filteredSubjects.length;
      int indexB = orderMap.containsKey(b['title'])
          ? orderMap[b['title']]!
          : filteredSubjects.length;
      return indexA.compareTo(indexB);
    });

    // Save the new order to local storage.
    await saveSubjects();
    //emit DvarMalchusReady
    emit(DvarmalchusReady(currentDate, dvarmalchus!, filteredSubjects, config!,
        hashlamot, comments, hebrewDate, firstDateOfWeek!));
  }
}
