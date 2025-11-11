import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dvarmalchus_flutter/core/constants/assets.dart';
import 'package:dvarmalchus_flutter/core/constants/constants.dart';
import 'package:dvarmalchus_flutter/core/cubit/analytics_cubit.dart';
import 'package:dvarmalchus_flutter/core/dm_pdf_viewer/dm_pdf_viewer.dart';
import 'package:dvarmalchus_flutter/core/ioc.dart';
import 'package:dvarmalchus_flutter/credits/credits_page.dart';
import 'package:dvarmalchus_flutter/hashlamot/hashlamot_page.dart';
import 'package:open_file/open_file.dart';
import 'package:dvarmalchus_flutter/home_page/presentation/cubit/dvarmalchus_cubit.dart';
import 'package:dvarmalchus_flutter/settings/cubit/settings_cubit.dart';
import 'package:dvarmalchus_flutter/settings/settings_page.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  @override
  void initState() {
    initializeDateFormatting('he', '');
    locator.get<DvarmalchusCubit>().init();
    super.initState();
  }

  // Function to show the dialog with a text field and two buttons
  void _showCommentDialog(
      BuildContext context, String existsComment, Function(String) onSave) {
    final TextEditingController controller =
        TextEditingController(text: existsComment);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "סימניה / הערות",
            textAlign: TextAlign.right,
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
                hintText:
                    "ניתן לציין היכן עצרתם בלימוד - במילים. פרק ד סעיף ו׳ / הערות וכו"),
            style: const TextStyle(),
            textAlign: TextAlign.right,
            maxLines: 3,
          ),
          actions: [
            TextButton(
              child: const Text("סגור"),
              onPressed: () {
                Navigator.of(context).pop(); // dismiss dialog
              },
            ),
            TextButton(
              child: const Text("שמור"),
              onPressed: () {
                onSave(controller.text); // pass comment text to callback
                Navigator.of(context).pop(); // dismiss dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: DMColors.primaryColor,
            iconTheme: IconTheme.of(context).copyWith(
              color: Colors.white,
            )),
        splashColor: DMColors.primaryColor,
        primarySwatch: DMColors.primaryColor,
        textSelectionTheme: TextSelectionTheme.of(context)
            .copyWith(cursorColor: DMColors.primaryColor),
        tabBarTheme: TabBarThemeData(
          unselectedLabelColor: Colors.grey[700],
          labelColor: DMColors.primaryColor,
          labelStyle: const TextStyle(color: Colors.white), // color for text
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: DMColors.primaryColor),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return DMColors.primaryColor; // color when selected
              }
              return Colors.white; // default color when not selected
            },
          ),
        ),
      ),
      home: BlocBuilder<DvarmalchusCubit, DvarmalchusState>(
        bloc: locator.get(),
        buildWhen: (previous, current) =>
            current is! PlayerStart &&
            current is! PlayerStop &&
            current is! PlayerInit &&
            current is! DvarMalchusDownloadProgress,
        builder: (context, state) {
          if (state is DvarmalchusNoInternet) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'יש לוודא שהחיבור לאינטרנט תקין ולנסות שוב',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              body: Container(
                color: Colors.white,
                child: Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                        // primary: Colors.white,
                        backgroundColor: DMColors.primaryColor),
                    onPressed: () {
                      locator.get<DvarmalchusCubit>().init();
                    },
                    child: const Text(
                      'נסו שוב',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          } else if (state is NoContentFound) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'לא נמצאו נתונים',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              body: Container(
                color: Colors.white,
                child: Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                        // primary: Colors.white,
                        backgroundColor: DMColors.primaryColor),
                    onPressed: () {
                      locator.get<DvarmalchusCubit>().init();
                    },
                    child: const Text(
                      'נסו שוב',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ),
            );
          } else if (state is ChooseRegion) {
            Widget cancelButton = TextButton(
              style: TextButton.styleFrom(
                  // primary: Colors.white,
                  backgroundColor: DMColors.primaryColor),
              onPressed: () {
                locator.get<AnalyticsCubit>().logEvent('country_il');
                locator.get<DvarmalchusCubit>().setCountry('il');
              },
              child: const Text(
                "ישראל",
                style: TextStyle(color: Colors.white),
              ),
            );
            Widget continueButton = TextButton(
              style: TextButton.styleFrom(
                  // primary: Colors.white,
                  backgroundColor: DMColors.primaryColor),
              onPressed: () {
                locator.get<AnalyticsCubit>().logEvent('country_us');
                locator.get<DvarmalchusCubit>().setCountry('us');
              },
              child: const Text(
                "חו״ל",
                style: TextStyle(color: Colors.white),
              ),
            );
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'בחר מיקום',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              body: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          continueButton,
                          cancelButton,
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else if (state is DvarmalchusReady) {
            if (state.noDataFound != null && state.noDataFound! == true) {
              Future.delayed(const Duration(microseconds: 800)).then(
                (value) {
                  showDialog(
                    context: context,
                    builder: (_) => const AlertDialog(
                      title: Text(
                        'אופס',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        'לא נמצא תוכן לתאריך המבוקש',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  );
                },
              );
            }
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      clipBehavior: Clip.hardEdge,
                      shape: const CircleBorder(),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new),
                        onPressed: () {
                          locator
                              .get<AnalyticsCubit>()
                              .logEvent('change_day_forward');
                          locator.get<DvarmalchusCubit>().changeDay(false);
                        },
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${DateFormat('EEEE', 'he').format(state.selectedDate).replaceAll('יום ', '')} - ${state.hebrewDate}\n${state.dvarmalchus.title}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const Spacer(),
                    Material(
                      color: Colors.transparent,
                      clipBehavior: Clip.hardEdge,
                      shape: const CircleBorder(),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          locator
                              .get<AnalyticsCubit>()
                              .logEvent('change_day_back');
                          locator.get<DvarmalchusCubit>().changeDay(true);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              drawer: Drawer(
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      padding: EdgeInsets.zero,
                      decoration: const BoxDecoration(
                        color: DMColors.primaryColor,
                      ),
                      child: Image.asset(DvarMalchusImages.ps_cover),
                    ),
                    // ListTile(
                    //   title: const Text('התחבר'),
                    //   onTap: () {
                    //     // Update the state of the app.
                    //     // ...
                    //   },
                    // ),
                    ListTile(
                      title: const Row(
                        children: [
                          Icon(Icons.settings),
                          Spacer(),
                          Text('הגדרות'),
                        ],
                      ),
                      onTap: () {
                        locator.get<AnalyticsCubit>().logEvent('settings_page');
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const SettingsScreenWidget(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: const Row(
                        children: [
                          Icon(Icons.fact_check_outlined),
                          Spacer(),
                          Text('דו״ח לימוד'),
                        ],
                      ),
                      onTap: () {
                        locator
                            .get<AnalyticsCubit>()
                            .logEvent('hashlamot_page');
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const HashlamotScreenWidget(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: const Row(
                        children: [
                          Icon(CupertinoIcons.heart_fill),
                          Spacer(),
                          Text('התודה והברכה'),
                        ],
                      ),
                      onTap: () {
                        locator.get<AnalyticsCubit>().logEvent('credits_page');
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const CreditsWidget(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  BlocBuilder<DvarmalchusCubit, DvarmalchusState>(
                    bloc: locator.get(),
                    buildWhen: (previous, current) =>
                        current is DvarMalchusDownloadProgress,
                    builder: (context, state) {
                      if (state is DvarMalchusDownloadProgress) {
                        if (state.progress == 0 || state.progress == 1) {
                          return Container();
                        } else {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                // Text(
                                //   'מוריד קובץ שבועי (${state.completedDownloads}/${state.totalDownloads})',
                                // ),
                                const Text(
                                  'מוריד קובץ שבועי',
                                ),
                                LinearProgressIndicator(
                                  value: state.progress,
                                  color: DMColors.primaryColor,
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              if (state.config.advertise != null) {
                                launchUrl(
                                    Uri.parse(state.config.advertise!.link));
                              }
                            },
                            child: SizedBox(
                              height: 200,
                              child: Center(
                                child: CachedNetworkImage(
                                    imageUrl: state.config.advertise != null
                                        ? state.config.advertise!.image
                                        : state.config.coverImage),
                              ),
                            ),
                          ),
                        ),
                        const Flexible(
                          flex: 0,
                          child: VerticalDivider(
                            color: DMColors.primaryColor,
                          ),
                        ),
                        Expanded(
                          child: ReorderableListView(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            onReorder: (int oldIndex, int newIndex) {
                              // Adjust newIndex if moving down the list.
                              if (newIndex > oldIndex) {
                                newIndex -= 1;
                              }
                              locator
                                  .get<DvarmalchusCubit>()
                                  .updateSubjectsPositions(
                                      oldIndex, newIndex, state.subjects);
                            },
                            children:
                                List.generate(state.subjects.length, (index) {
                              // Get your 'readed' and 'comment' values from the state
                              var weekday = state.selectedDate.weekday == 7
                                  ? 1
                                  : state.selectedDate.weekday + 1;
                              var readed = state.hashlamot[state.firstDateOfWeek
                                          .toIso8601String()
                                          .split('T')[0]]?[
                                      '${state.subjects[index]['title']}-$weekday'] ??
                                  false;
                              var comment = state.comments[state.firstDateOfWeek
                                          .toIso8601String()
                                          .split('T')[0]]?[
                                      '${state.subjects[index]['title']}-$weekday'] ??
                                  '';
                              if (readed is String) {
                                locator.get<DvarmalchusCubit>().resetPrefs();
                                readed = false;
                              }

                              return Container(
                                key: ValueKey(state.subjects[index]['title']),
                                child: Column(
                                  children: [
                                    InkWell(
                                      splashColor: Colors.red,
                                      onTap: () {
                                        var subjectIndex =
                                            DateFormat('ddMMyyyy', 'en')
                                                .format(state.selectedDate);
                                        var isWeekly = state.subjects[index]
                                                ['type'] ==
                                            'weekly';
                                        if (isWeekly) {
                                          subjectIndex = DateFormat(
                                                  'ddMMyyyy', 'en')
                                              .format(state.firstDateOfWeek);
                                        }
                                        var localPdfPath =
                                            '${locator.get<DvarmalchusCubit>().filesBasePath!}/$subjectIndex/${state.subjects[index]['title']}';
                                        locator.get<AnalyticsCubit>().logEvent(
                                            state.subjects[index]['title']!);
                                        
                                        // Check if user wants to use external PDF viewer
                                        var useExternalViewer = locator.get<SettingsCubit>().readUseExternalPdfViewer();
                                        
                                        if (useExternalViewer) {
                                          // Open with external PDF viewer
                                          OpenFile.open(localPdfPath);
                                        } else {
                                          // Open with internal PDF viewer
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  DMPdfViewer(
                                                title: state.subjects[index]
                                                    ['title']!,
                                                localPdfPath: localPdfPath,
                                                pdfPath:
                                                    'https://s3.amazonaws.com/DvarMalchus/${state.subjects[index]['url']}',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            value: readed,
                                            onChanged: (value) {
                                              Map<String, dynamic> hashlama = {
                                                'subject': state.subjects[index]
                                                    ['title'],
                                                'parasha':
                                                    state.dvarmalchus.title,
                                                'day': weekday,
                                                'year': state.selectedDate.year,
                                                'user': 'itzhar.dev@gmail.com',
                                              };
                                              locator
                                                  .get<DvarmalchusCubit>()
                                                  .readed(value ?? false,
                                                      hashlama, state.subjects);
                                              locator
                                                  .get<AnalyticsCubit>()
                                                  .logEvent(
                                                      '${state.subjects[index]['title']}_checked');
                                            },
                                          ),
                                          if (state.subjects[index]
                                                      ['recordMap'] !=
                                                  null &&
                                              state.subjects[index]
                                                      ['recordMap'] !=
                                                  null &&
                                              state.subjects[index]
                                                      ['recordMap']![index] !=
                                                  null &&
                                              state.subjects[index]
                                                      ['recordMap']![index] !=
                                                  '')
                                            BlocBuilder<DvarmalchusCubit,
                                                DvarmalchusState>(
                                              bloc: locator.get(),
                                              buildWhen: (previous, current) =>
                                                  current is PlayerStart ||
                                                  current is PlayerStop ||
                                                  current is PlayerInit,
                                              builder: (context, stte) {
                                                // print(state.subjects[index]
                                                //     ['recordMap']);
                                                if (stte is PlayerInit &&
                                                    stte.subject ==
                                                        state.subjects[index]
                                                            ['title']) {
                                                  return GestureDetector(
                                                    onTap: () async {
                                                      locator
                                                          .get<
                                                              DvarmalchusCubit>()
                                                          .stop();
                                                    },
                                                    child: const SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child:
                                                            CircularProgressIndicator()),
                                                  );
                                                } else if (stte
                                                    is PlayerStart) {
                                                  return GestureDetector(
                                                    onTap: () async {
                                                      if (stte.subject ==
                                                          state.subjects[index]
                                                              ['title']) {
                                                        locator
                                                            .get<
                                                                DvarmalchusCubit>()
                                                            .stop();
                                                      } else {
                                                        locator
                                                            .get<
                                                                DvarmalchusCubit>()
                                                            .play(
                                                                context,
                                                                state.subjects[
                                                                        index]
                                                                    ['title']!,
                                                                state.subjects[
                                                                        index][
                                                                    'recordMap']!);
                                                      }
                                                    },
                                                    child: stte.subject ==
                                                            state.subjects[
                                                                index]['title']
                                                        ? const Icon(
                                                            Icons.pause)
                                                        : const Icon(
                                                            Icons.volume_up),
                                                  );
                                                } else {
                                                  return GestureDetector(
                                                    onTap: () async {
                                                      locator
                                                          .get<
                                                              DvarmalchusCubit>()
                                                          .play(
                                                              context,
                                                              state.subjects[
                                                                      index]
                                                                  ['title']!,
                                                              state.subjects[
                                                                          index]
                                                                      [
                                                                      'recordMap']![
                                                                  weekday]!);
                                                    },
                                                    child: const Icon(
                                                        Icons.volume_up),
                                                  );
                                                }
                                              },
                                            ),
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 4.0),
                                            child: Text(
                                              state.subjects[index]['title']!,
                                              textAlign: TextAlign.right,
                                              style: state.subjects[index]
                                                          ['text_color'] !=
                                                      null
                                                  ? TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.035,
                                                      color: fromHex(
                                                          state.subjects[index]
                                                              ['text_color']!),
                                                    )
                                                  : TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.035,
                                                    ),
                                            ),
                                          ),
                                          GestureDetector(
                                            child: Icon(comment == ''
                                                ? Icons.bookmark_border
                                                : Icons.bookmark),
                                            onTap: () {
                                              _showCommentDialog(
                                                  context, comment,
                                                  (String comment) {
                                                Map<String, dynamic> hashlama =
                                                    {
                                                  'subject': state
                                                      .subjects[index]['title'],
                                                  'parasha':
                                                      state.dvarmalchus.title,
                                                  'day': weekday,
                                                  'year':
                                                      state.selectedDate.year,
                                                  'user':
                                                      'itzhar.dev@gmail.com',
                                                };
                                                locator
                                                    .get<DvarmalchusCubit>()
                                                    .comment(comment, hashlama,
                                                        state.subjects);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (index < state.subjects.length - 1)
                                      const Divider(height: 1),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: DMColors.primaryColor,
                    height: 60,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimatedTextKit(
                          totalRepeatCount: 2,
                          animatedTexts: [
                            TyperAnimatedText(
                                '${state.config.inMemoryOf.title}\n${state.config.inMemoryOf.description}',
                                textAlign: TextAlign.center,
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )),
                          ],
                          onTap: () {
                            locator
                                .get<AnalyticsCubit>()
                                .logEvent('im_memory_dialog_opend');
                            showMaterialModalBottomSheet(
                              context: context,
                              builder: (context) => SizedBox(
                                height: 350,
                                child: Column(
                                    children: [
                                      Container(
                                        color: DMColors.primaryColor,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${state.config.inMemoryOf.title}\n${state.config.inMemoryOf.description}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0, left: 8.0),
                                                child: Text(
                                                  state.config.inMemoryOf.more,
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: CachedNetworkImage(
                                                  width: 120,
                                                  imageUrl: state
                                                      .config.inMemoryOf.image),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                            );
                          },
                        ),
                        // child: Text(
                        //   '${state.config.inMemoryOf.title}\n${state.config.inMemoryOf.description}',
                        //   textAlign: TextAlign.center,
                        //   style: const TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'אנא המתן',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
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

  Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
