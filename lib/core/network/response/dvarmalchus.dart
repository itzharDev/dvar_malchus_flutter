import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'dvarmalchus.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Dvarmalchus extends HiveObject {
  @HiveField(0)
  final String country;
  @HiveField(1)
  final Content content;
  @HiveField(2)
  final Records records;
  @HiveField(3)
  final List<Extra> extras;
  @HiveField(4)
  String sunday_date;
  @HiveField(5)
  final String title;
  Dvarmalchus({
    required this.country,
    required this.content,
    required this.records,
    required this.extras,
    required this.sunday_date,
    required this.title,
  });
  factory Dvarmalchus.fromJson(Map<String, dynamic> json) =>
      _$DvarmalchusFromJson(json);

  Map<String, dynamic> toJson() => _$DvarmalchusToJson(this);
}

@JsonSerializable()
class Content {
  final String chumash_1;
  final String chumash_2;
  final String chumash_3;
  final String chumash_4;
  final String chumash_5;
  final String chumash_6;
  final String chumash_7;
  final String dvarMalchus;
  final String rambam_1_1;
  final String rambam_1_2;
  final String rambam_1_3;
  final String rambam_1_4;
  final String rambam_1_5;
  final String rambam_1_6;
  final String rambam_1_7;
  final String rambam_3_1;
  final String rambam_3_2;
  final String rambam_3_3;
  final String rambam_3_4;
  final String rambam_3_5;
  final String rambam_3_6;
  final String rambam_3_7;
  final String seferm_1;
  final String seferm_2;
  final String seferm_3;
  final String seferm_4;
  final String seferm_5;
  final String seferm_6;
  final String seferm_7;
  final String tanya_1;
  final String tanya_2;
  final String tanya_3;
  final String tanya_4;
  final String tanya_5;
  final String tanya_6;
  final String tanya_7;
  final String tehilim_1;
  final String tehilim_2;
  final String tehilim_3;
  final String tehilim_4;
  final String tehilim_5;
  final String tehilim_6;
  final String tehilim_7;
  final String yomyom_1;
  final String yomyom_2;
  final String yomyom_3;
  final String yomyom_4;
  final String yomyom_5;
  final String yomyom_6;
  final String yomyom_7;
  Content({
    required this.chumash_1,
    required this.chumash_2,
    required this.chumash_3,
    required this.chumash_4,
    required this.chumash_5,
    required this.chumash_6,
    required this.chumash_7,
    required this.dvarMalchus,
    required this.rambam_1_1,
    required this.rambam_1_2,
    required this.rambam_1_3,
    required this.rambam_1_4,
    required this.rambam_1_5,
    required this.rambam_1_6,
    required this.rambam_1_7,
    required this.rambam_3_1,
    required this.rambam_3_2,
    required this.rambam_3_3,
    required this.rambam_3_4,
    required this.rambam_3_5,
    required this.rambam_3_6,
    required this.rambam_3_7,
    required this.seferm_1,
    required this.seferm_2,
    required this.seferm_3,
    required this.seferm_4,
    required this.seferm_5,
    required this.seferm_6,
    required this.seferm_7,
    required this.tanya_1,
    required this.tanya_2,
    required this.tanya_3,
    required this.tanya_4,
    required this.tanya_5,
    required this.tanya_6,
    required this.tanya_7,
    required this.tehilim_1,
    required this.tehilim_2,
    required this.tehilim_3,
    required this.tehilim_4,
    required this.tehilim_5,
    required this.tehilim_6,
    required this.tehilim_7,
    required this.yomyom_1,
    required this.yomyom_2,
    required this.yomyom_3,
    required this.yomyom_4,
    required this.yomyom_5,
    required this.yomyom_6,
    required this.yomyom_7,
  });
  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);

  String getChumash(int day) {
    switch (day) {
      case 1:
        return chumash_1;
      case 2:
        return chumash_2;
      case 3:
        return chumash_3;
      case 4:
        return chumash_4;
      case 5:
        return chumash_5;
      case 6:
        return chumash_6;
      case 7:
        return chumash_7;
    }
    return '';
  }

  String getTanya(int day) {
    switch (day) {
      case 1:
        return tanya_1;
      case 2:
        return tanya_2;
      case 3:
        return tanya_3;
      case 4:
        return tanya_4;
      case 5:
        return tanya_5;
      case 6:
        return tanya_6;
      case 7:
        return tanya_7;
    }
    return '';
  }

  String getYomyom(int day) {
    switch (day) {
      case 1:
        return yomyom_1;
      case 2:
        return yomyom_2;
      case 3:
        return yomyom_3;
      case 4:
        return yomyom_4;
      case 5:
        return yomyom_5;
      case 6:
        return yomyom_6;
      case 7:
        return yomyom_7;
    }
    return '';
  }

  String getRambamOne(int day) {
    switch (day) {
      case 1:
        return rambam_1_1;
      case 2:
        return rambam_1_2;
      case 3:
        return rambam_1_3;
      case 4:
        return rambam_1_4;
      case 5:
        return rambam_1_5;
      case 6:
        return rambam_1_6;
      case 7:
        return rambam_1_7;
    }
    return '';
  }

  String getRambamThree(int day) {
    switch (day) {
      case 1:
        return rambam_3_1;
      case 2:
        return rambam_3_2;
      case 3:
        return rambam_3_3;
      case 4:
        return rambam_3_4;
      case 5:
        return rambam_3_5;
      case 6:
        return rambam_3_6;
      case 7:
        return rambam_3_7;
    }
    return '';
  }

  String getTehilim(int day) {
    switch (day) {
      case 1:
        return tehilim_1;
      case 2:
        return tehilim_2;
      case 3:
        return tehilim_3;
      case 4:
        return tehilim_4;
      case 5:
        return tehilim_5;
      case 6:
        return tehilim_6;
      case 7:
        return tehilim_7;
    }
    return '';
  }

  String getDvarMalchus() {
    return dvarMalchus;
  }

  String getSeferM(int day) {
    switch (day) {
      case 1:
        return seferm_1;
      case 2:
        return seferm_2;
      case 3:
        return seferm_3;
      case 4:
        return seferm_4;
      case 5:
        return seferm_5;
      case 6:
        return seferm_6;
      case 7:
        return seferm_7;
    }
    return '';
  }
}

@JsonSerializable()
class Records {
  final String chumash_1;
  final String chumash_2;
  final String chumash_3;
  final String chumash_4;
  final String chumash_5;
  final String chumash_6;
  final String chumash_7;
  final String dvarMalchus;
  final String rambam_1_1;
  final String rambam_1_2;
  final String rambam_1_3;
  final String rambam_1_4;
  final String rambam_1_5;
  final String rambam_1_6;
  final String rambam_1_7;
  final String rambam_3_1;
  final String rambam_3_2;
  final String rambam_3_3;
  final String rambam_3_4;
  final String rambam_3_5;
  final String rambam_3_6;
  final String rambam_3_7;
  final String seferm_1;
  final String seferm_2;
  final String seferm_3;
  final String seferm_4;
  final String seferm_5;
  final String seferm_6;
  final String seferm_7;
  final String tanya_1;
  final String tanya_2;
  final String tanya_3;
  final String tanya_4;
  final String tanya_5;
  final String tanya_6;
  final String tanya_7;
  final String tehilim_1;
  final String tehilim_2;
  final String tehilim_3;
  final String tehilim_4;
  final String tehilim_5;
  final String tehilim_6;
  final String tehilim_7;
  final String yomyom_1;
  final String yomyom_2;
  final String yomyom_3;
  final String yomyom_4;
  final String yomyom_5;
  final String yomyom_6;
  final String yomyom_7;
  Records({
    required this.chumash_1,
    required this.chumash_2,
    required this.chumash_3,
    required this.chumash_4,
    required this.chumash_5,
    required this.chumash_6,
    required this.chumash_7,
    required this.dvarMalchus,
    required this.rambam_1_1,
    required this.rambam_1_2,
    required this.rambam_1_3,
    required this.rambam_1_4,
    required this.rambam_1_5,
    required this.rambam_1_6,
    required this.rambam_1_7,
    required this.rambam_3_1,
    required this.rambam_3_2,
    required this.rambam_3_3,
    required this.rambam_3_4,
    required this.rambam_3_5,
    required this.rambam_3_6,
    required this.rambam_3_7,
    required this.seferm_1,
    required this.seferm_2,
    required this.seferm_3,
    required this.seferm_4,
    required this.seferm_5,
    required this.seferm_6,
    required this.seferm_7,
    required this.tanya_1,
    required this.tanya_2,
    required this.tanya_3,
    required this.tanya_4,
    required this.tanya_5,
    required this.tanya_6,
    required this.tanya_7,
    required this.tehilim_1,
    required this.tehilim_2,
    required this.tehilim_3,
    required this.tehilim_4,
    required this.tehilim_5,
    required this.tehilim_6,
    required this.tehilim_7,
    required this.yomyom_1,
    required this.yomyom_2,
    required this.yomyom_3,
    required this.yomyom_4,
    required this.yomyom_5,
    required this.yomyom_6,
    required this.yomyom_7,
  });
  factory Records.fromJson(Map<String, dynamic> json) =>
      _$RecordsFromJson(json);

  Map<String, dynamic> toJson() => _$RecordsToJson(this);

  String getChumash(int day) {
    switch (day) {
      case 1:
        return chumash_1;
      case 2:
        return chumash_2;
      case 3:
        return chumash_3;
      case 4:
        return chumash_4;
      case 5:
        return chumash_5;
      case 6:
        return chumash_6;
      case 7:
        return chumash_7;
    }
    return '';
  }

  String getTanya(int day) {
    switch (day) {
      case 1:
        return tanya_1;
      case 2:
        return tanya_2;
      case 3:
        return tanya_3;
      case 4:
        return tanya_4;
      case 5:
        return tanya_5;
      case 6:
        return tanya_6;
      case 7:
        return tanya_7;
    }
    return '';
  }

  String getYomyom(int day) {
    switch (day) {
      case 1:
        return yomyom_1;
      case 2:
        return yomyom_2;
      case 3:
        return yomyom_3;
      case 4:
        return yomyom_4;
      case 5:
        return yomyom_5;
      case 6:
        return yomyom_6;
      case 7:
        return yomyom_7;
    }
    return '';
  }

  String getRambamOne(int day) {
    switch (day) {
      case 1:
        return rambam_1_1;
      case 2:
        return rambam_1_2;
      case 3:
        return rambam_1_3;
      case 4:
        return rambam_1_4;
      case 5:
        return rambam_1_5;
      case 6:
        return rambam_1_6;
      case 7:
        return rambam_1_7;
    }
    return '';
  }

  String getRambamThree(int day) {
    switch (day) {
      case 1:
        return rambam_3_1;
      case 2:
        return rambam_3_2;
      case 3:
        return rambam_3_3;
      case 4:
        return rambam_3_4;
      case 5:
        return rambam_3_5;
      case 6:
        return rambam_3_6;
      case 7:
        return rambam_3_7;
    }
    return '';
  }

  String getTehilim(int day) {
    switch (day) {
      case 1:
        return tehilim_1;
      case 2:
        return tehilim_2;
      case 3:
        return tehilim_3;
      case 4:
        return tehilim_4;
      case 5:
        return tehilim_5;
      case 6:
        return tehilim_6;
      case 7:
        return tehilim_7;
    }
    return '';
  }

  String getDvarMalchus() {
    return dvarMalchus;
  }

  String getSeferM(int day) {
    switch (day) {
      case 1:
        return seferm_1;
      case 2:
        return seferm_2;
      case 3:
        return seferm_3;
      case 4:
        return seferm_4;
      case 5:
        return seferm_5;
      case 6:
        return seferm_6;
      case 7:
        return seferm_7;
    }
    return '';
  }
}

@JsonSerializable()
class Extra {
  final String subject;
  final String webSubject;
  final String position;
  final String text_color;
  final String type;
  final List<String>? arr;
  final String? url;
  Extra({
    required this.subject,
    required this.webSubject,
    required this.position,
    required this.text_color,
    required this.type,
    required this.arr,
    required this.url,
  });
  factory Extra.fromJson(Map<String, dynamic> json) => _$ExtraFromJson(json);

  Map<String, dynamic> toJson() => _$ExtraToJson(this);
}
