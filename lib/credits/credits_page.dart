import 'package:dvarmalchus_flutter/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsWidget extends StatefulWidget {
  const CreditsWidget({Key? key}) : super(key: key);

  @override
  State<CreditsWidget> createState() => _CreditsWidgetState();
}

class _CreditsWidgetState extends State<CreditsWidget> {
  var nameStyle = const TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
  var descriptionStyle = const TextStyle(fontSize: 20);
  var emailStyle = const TextStyle(
      fontSize: 20, decoration: TextDecoration.underline, color: Colors.blue);
  var spacer = const SizedBox(
    height: 15,
  );
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
        child: Scaffold(
          appBar: AppBar(
          title: const Text(
            'תודה רבה לתומכים',
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
              Text(
                'מנחם מענדל לרנר',
                style: nameStyle,
                textAlign: TextAlign.right,
              ),
              Text(
                'על עריכת התוכן, אפיון ושיפור האפליקציה',
                textAlign: TextAlign.right,
                style: descriptionStyle,
              ),
              spacer,
              Text(
                'ישראל פרסיקו',
                textAlign: TextAlign.right,
                style: nameStyle,
              ),
              Text(
                'על תרומתו בפיתוח האפליקציה',
                textAlign: TextAlign.right,
                style: descriptionStyle,
              ),
              GestureDetector(
                onTap: () async {
                  if (!await launchUrl(
                      Uri.parse('mailto:israelpersiko770@gmail.com'))) {
                    throw 'Could not launch email';
                  }
                },
                child: Text(
                  'israelpersiko770@gmail.com',
                  textAlign: TextAlign.right,
                  style: emailStyle,
                ),
              ),
              spacer,
              Text(
                'שוקי קורנט',
                textAlign: TextAlign.right,
                style: nameStyle,
              ),
              Text(
                'DevOps & צד שרת',
                textAlign: TextAlign.right,
                style: descriptionStyle,
              ),
              spacer,
              Text(
                'יוסף כהן',
                textAlign: TextAlign.right,
                style: nameStyle,
              ),
              Text(
                'מפתח אפליקציות - בפרט בתחום היהדות בשפה הצרפתית - על השימוש ברש״י מנוקד לחומש',
                textAlign: TextAlign.right,
                style: descriptionStyle,
              ),
              GestureDetector(
                onTap: () async {
                  if (!await launchUrl(
                      Uri.parse('mailto:yossicohen@hotmail.fr'))) {
                    throw 'Could not launch email';
                  }
                },
                child: Text(
                  'yossicohen@hotmail.fr',
                  textAlign: TextAlign.right,
                  style: emailStyle,
                ),
              ),
              spacer,
              Text(
                'הרב אליעזר ברוק ע״ה',
                textAlign: TextAlign.right,
                style: nameStyle,
              ),
              Text(
                'המטה להפצת בשורת הרבי ב׳דבר מלכות׳',
                textAlign: TextAlign.right,
                style: descriptionStyle,
              ),
              spacer,
              Text(
                'הרב נדב כהן',
                textAlign: TextAlign.right,
                style: nameStyle,
              ),
              Text(
                'מחבר הספר \'מודעות יהודית\' אשר תרם את חלקו בהקלטת השיעורים היומיים של החומש, תהילים ותניא. ניתן לפנות בשאלות בהודעה לפלא',
                textAlign: TextAlign.right,
                style: descriptionStyle,
              ),
              GestureDetector(
                onTap: () async {
                  if (!await launchUrl(Uri.parse('tel:0549770959'))) {
                    throw 'Could not launch tel';
                  }
                },
                child: Text(
                  '054-9770-959',
                  textAlign: TextAlign.right,
                  style: emailStyle,
                ),
              ),
              spacer,
              Text(
                'הרב אחיקם פרייליך',
                textAlign: TextAlign.right,
                style: nameStyle,
              ),
              Text(
                'על הקלטות שיעורי הרמבם היומי',
                textAlign: TextAlign.right,
                style: descriptionStyle,
              ),
              spacer,
              Text(
                'מערכת \'המעשה הוא העיקר\'',
                textAlign: TextAlign.right,
                style: nameStyle,
              ),
              Text(
                'עברית - www.moshiach.net/blind\nאנגלית - http://ichossid.com',
                textAlign: TextAlign.right,
                style: descriptionStyle,
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
