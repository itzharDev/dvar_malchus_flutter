import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dvarmalchus_flutter/core/constants/constants.dart';
import 'package:dvarmalchus_flutter/core/cubit/analytics_cubit.dart';
import 'package:dvarmalchus_flutter/core/ioc.dart';
import 'package:dvarmalchus_flutter/home_page/presentation/cubit/dvarmalchus_cubit.dart';
import 'package:dvarmalchus_flutter/settings/cubit/settings_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreenWidget extends StatefulWidget {
  const SettingsScreenWidget({Key? key}) : super(key: key);

  @override
  State<SettingsScreenWidget> createState() => _SettingsScreenWidgetState();
}

class _SettingsScreenWidgetState extends State<SettingsScreenWidget> {
  List<Map<String, dynamic>> subjects = [];

  @override
  void initState() {
    super.initState();
    locator.get<SettingsCubit>().init();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = prefs.getString('subjects');
    if (subjectsJson != null) {
      final List<dynamic> list = jsonDecode(subjectsJson);
      // Ensure that each subject has an "enabled" flag.
      subjects = list
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
          .map((subject) {
        subject["enabled"] = subject["enabled"] ?? true;
        return subject;
      }).toList();
    } else {
      // Use default subjects if nothing is saved
      subjects = [
        {"title": 'דבר מלכות', "enabled": true},
        {"title": 'חומש יומי', "enabled": true},
        {"title": 'תהילים', "enabled": true},
        {"title": 'תניא יומי', "enabled": true},
        {"title": 'היום יום', "enabled": true},
        {"title": 'רמב"ם 3 פרקים', "enabled": true},
        {"title": 'רמב"ם פרק 1', "enabled": true},
        {"title": 'ספר המצוות', "enabled": true},
      ];
      await _saveSubjects();
    }
    setState(() {});
  }

  Future<void> _saveSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('subjects', jsonEncode(subjects));
    locator.get<DvarmalchusCubit>().init();
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
          labelStyle: const TextStyle(color: Colors.white),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: DMColors.primaryColor),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return DMColors.primaryColor;
              }
              return Colors.white;
            },
          ),
        ),
      ),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
          title: const Text(
            'הגדרות',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 20.0,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              // Existing setting for "הצג תניא עם ביאור"
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: DMColors.primaryColor,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  locator.get<SettingsCubit>().clearDocumentsDirectory();
                },
                child: const Text(
                  'ניקוי קבצים ממכשיר הפלאפון',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(thickness: 2),
              Row(
                children: [
                  const Spacer(),
                  const Text('הצג תניא עם ביאור'),
                  BlocBuilder<SettingsCubit, SettingsState>(
                    bloc: locator.get(),
                    builder: (context, state) {
                      if (state is ShowTanyaWithBiurChanged) {
                        return Checkbox(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: state.showTanyaWithBiur,
                          onChanged: (value) {
                            locator
                                .get<SettingsCubit>()
                                .showTanyaWithBiur(value!);
                          },
                        );
                      }
                      return Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: true,
                        onChanged: (value) {
                          locator
                              .get<SettingsCubit>()
                              .showTanyaWithBiur(value!);
                          locator
                              .get<AnalyticsCubit>()
                              .logEvent('settings_tanya_with_biur_$value');
                        },
                      );
                    },
                  )
                ],
              ),
              const Divider(thickness: 2),
              // PDF Viewer setting
              Row(
                children: [
                  const Spacer(),
                  const Text('פתח PDF במציג חיצוני'),
                  BlocBuilder<SettingsCubit, SettingsState>(
                    bloc: locator.get(),
                    builder: (context, state) {
                      if (state is UseExternalPdfViewerChanged) {
                        return Checkbox(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: state.useExternalPdfViewer,
                          onChanged: (value) {
                            locator
                                .get<SettingsCubit>()
                                .setUseExternalPdfViewer(value!);
                            locator
                                .get<AnalyticsCubit>()
                                .logEvent('settings_external_pdf_$value');
                          },
                        );
                      }
                      return Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: false,
                        onChanged: (value) {
                          locator
                              .get<SettingsCubit>()
                              .setUseExternalPdfViewer(value!);
                          locator
                              .get<AnalyticsCubit>()
                              .logEvent('settings_external_pdf_$value');
                        },
                      );
                    },
                  )
                ],
              ),
              const Divider(thickness: 2),
              // Existing setting for location change
              GestureDetector(
                onTap: () {
                  locator.get<SettingsCubit>().changeLocation();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('בחר מיקום'),
                        BlocConsumer<SettingsCubit, SettingsState>(
                          listenWhen: (previous, current) =>
                              current is ChangeLocation,
                          listener: (context, state) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                Widget cancelButton = TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: DMColors.primaryColor),
                                  onPressed: () {
                                    locator
                                        .get<AnalyticsCubit>()
                                        .logEvent('settings_country_il');
                                    locator
                                        .get<SettingsCubit>()
                                        .setCountry('il');
                                    locator
                                        .get<DvarmalchusCubit>()
                                        .getDvarMalchus();
                                    Navigator.pop(context);
                                  },
                                  child: const Text("ישראל"),
                                );
                                Widget continueButton = TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: DMColors.primaryColor),
                                  onPressed: () {
                                    locator
                                        .get<AnalyticsCubit>()
                                        .logEvent('settings_country_us');
                                    locator
                                        .get<SettingsCubit>()
                                        .setCountry('us');
                                    locator
                                        .get<DvarmalchusCubit>()
                                        .getDvarMalchus();
                                    Navigator.pop(context);
                                  },
                                  child: const Text("חו״ל"),
                                );
                                return AlertDialog(
                                  content: const Row(
                                    children: [
                                      Text(
                                        'בחר מיקום',
                                        textAlign: TextAlign.end,
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  actions: [
                                    continueButton,
                                    cancelButton,
                                  ],
                                );
                              },
                            );
                          },
                          bloc: locator.get(),
                          buildWhen: (previous, current) =>
                              current is LocationChanged,
                          builder: (context, state) {
                            if (state is LocationChanged) {
                              return Text(
                                  state.location == 'il' ? 'ישראל' : 'חו״ל');
                            }
                            return const Text('ישראל');
                          },
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.location_on,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
              const Divider(thickness: 2),
              // New section: Choose subjects for main page availability
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'בחר נושאים זמינים במסך הראשי:',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              if (subjects.isEmpty)
                const Center(child: CircularProgressIndicator())
              else
                ...subjects.map((subject) {
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      subject["title"],
                      textAlign: TextAlign.right,
                    ),
                    value: subject["enabled"] ?? true,
                    onChanged: (value) {
                      setState(() {
                        subject["enabled"] = value;
                      });
                      _saveSubjects();
                    },
                  );
                }).toList(),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
