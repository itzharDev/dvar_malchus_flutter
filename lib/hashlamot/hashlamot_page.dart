import 'package:dvarmalchus_flutter/core/constants/constants.dart';
import 'package:dvarmalchus_flutter/core/cubit/analytics_cubit.dart';
import 'package:dvarmalchus_flutter/core/ioc.dart';
import 'package:dvarmalchus_flutter/home_page/presentation/cubit/dvarmalchus_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HashlamotScreenWidget extends StatefulWidget {
  const HashlamotScreenWidget({Key? key}) : super(key: key);

  @override
  State<HashlamotScreenWidget> createState() => _HashlamotScreenWidgetState();
}

class _HashlamotScreenWidgetState extends State<HashlamotScreenWidget> {
  @override
  void initState() {
    super.initState();
    // Only init if not already in ready state
    final cubit = locator.get<DvarmalchusCubit>();
    if (cubit.state is! DvarmalchusReady) {
      cubit.init();
    }
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
      home: SafeArea(
        child: BlocBuilder<DvarmalchusCubit, DvarmalchusState>(
          bloc: locator.get(),
          builder: (ctx, state) {
            if (state is DvarmalchusReady) {
            var subjects = [
              {"title": 'דבר מלכות'},
              {"title": 'חומש יומי'},
              {"title": 'תהילים'},
              {"title": 'תניא יומי'},
              {"title": 'היום יום'},
              {"title": 'רמב"ם 3 פרקים'},
              {"title": 'רמב"ם פרק 1'},
              {"title": 'ספר המצוות'},
            ];
            var currentDayIndex = getCurrentDayIndex(state.selectedDate);
            for (var extra in state.dvarmalchus.extras) {
              subjects.insert(int.parse(extra.position), {
                "title": extra.subject,
                "text_color": extra.text_color,
                'url': extra.url != null && extra.url!.isNotEmpty
                    ? extra.url!
                    : extra.arr![currentDayIndex - 1]
              });
            }

            // [1, 2, 3, 4, 5, 6, 7].forEach((num) {
            //   print(num.toString() +
            //       ' - ' +
            //       (state.hashlamot[state.firstDateOfWeek
            //                       .toIso8601String()
            //                       .split('T')[0]]
            //                   ?['חומש יומי' + '-' + num.toString()] ??
            //               false)
            //           .toString());
            // });
            // print('state.firstDateOfWeek end');

            return Scaffold(
                appBar: AppBar(
                  title: Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        clipBehavior: Clip.hardEdge,
                        shape: const CircleBorder(),
                        child: IconButton(
                          icon: const Icon(CupertinoIcons.backward_fill),
                          onPressed: () {
                            locator
                                .get<AnalyticsCubit>()
                                .logEvent('hashlamot_change_week_forward');
                            locator.get<DvarmalchusCubit>().changeWeek(false);
                          },
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'דו״ח לימוד\n${state.dvarmalchus.title}',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      Material(
                        color: Colors.transparent,
                        clipBehavior: Clip.hardEdge,
                        shape: const CircleBorder(),
                        child: IconButton(
                          icon: const Icon(CupertinoIcons.forward_fill),
                          onPressed: () {
                            locator
                                .get<AnalyticsCubit>()
                                .logEvent('hashlamot_change_week_back');
                            locator.get<DvarmalchusCubit>().changeWeek(true);
                          },
                        ),
                      ),
                    ],
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('    ז'),
                                Text(' ו'),
                                Text('  ה'),
                                Text('  ד'),
                                Text('  ג'),
                                Text('ב'),
                                Text('א'),
                                // Spacer(),
                                SizedBox(
                                  width: 100,
                                ),
                              ],
                            ),
                            ...subjects
                                .map((subject) => Row(
                                      children: [
                                        //7
                                        Checkbox(
                                          value: state.hashlamot[state
                                                      .firstDateOfWeek
                                                      .toIso8601String()
                                                      .split('T')[0]]
                                                  ?['${subject['title']}-7'] ??
                                              false,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          onChanged: (value) {},
                                        ),
                                        //6
                                        Checkbox(
                                          value: state.hashlamot[state
                                                      .firstDateOfWeek
                                                      .toIso8601String()
                                                      .split('T')[0]]
                                                  ?['${subject['title']}-6'] ??
                                              false,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          onChanged: (value) {},
                                        ),
                                        //5
                                        Checkbox(
                                          value: state.hashlamot[state
                                                      .firstDateOfWeek
                                                      .toIso8601String()
                                                      .split('T')[0]]
                                                  ?['${subject['title']}-5'] ??
                                              false,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          onChanged: (value) {},
                                        ),
                                        //4
                                        Checkbox(
                                          value: state.hashlamot[state
                                                      .firstDateOfWeek
                                                      .toIso8601String()
                                                      .split('T')[0]]
                                                  ?['${subject['title']}-4'] ??
                                              false,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          onChanged: (value) {},
                                        ),
                                        //3
                                        Checkbox(
                                          value: state.hashlamot[state
                                                      .firstDateOfWeek
                                                      .toIso8601String()
                                                      .split('T')[0]]
                                                  ?['${subject['title']}-3'] ??
                                              false,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          onChanged: (value) {},
                                        ),
                                        //2
                                        Checkbox(
                                          value: state.hashlamot[state
                                                      .firstDateOfWeek
                                                      .toIso8601String()
                                                      .split('T')[0]]
                                                  ?['${subject['title']}-2'] ??
                                              false,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          onChanged: (value) {},
                                        ),
                                        //1
                                        Checkbox(
                                          value: state.hashlamot[state
                                                      .firstDateOfWeek
                                                      .toIso8601String()
                                                      .split('T')[0]]
                                                  ?['${subject['title']}-1'] ??
                                              false,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          onChanged: (value) {},
                                        ),
                                        const Spacer(),
                                        Text(
                                          subject['title']!,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03),
                                        ),
                                      ],
                                    ))
                                .toList()
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'אנא המתן',
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
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
            }
          },
        ),
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
}
