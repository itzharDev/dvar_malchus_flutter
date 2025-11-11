import 'package:json_annotation/json_annotation.dart';
part 'config.g.dart';

@JsonSerializable()
class DvarMalchusConfig {
  final Aws aws;
  final InMemoryOf inMemoryOf;
  final Advertise? advertise;
  final String coverImage;
  final String ios;
  final String android;
  final String hebDate;
  final int currentMonthDays;
  final int lastMonthDays;
  final int nextMonthDays;
  final bool isLeapYear;
  DvarMalchusConfig({
    required this.aws,
    required this.inMemoryOf,
    required this.advertise,
    required this.coverImage,
    required this.ios,
    required this.android,
    required this.hebDate,
    required this.currentMonthDays,
    required this.lastMonthDays,
    required this.nextMonthDays,
    required this.isLeapYear,
  });

  factory DvarMalchusConfig.fromJson(Map<String, dynamic> json) =>
      _$DvarMalchusConfigFromJson(json);

  Map<String, dynamic> toJson() => _$DvarMalchusConfigToJson(this);
}

@JsonSerializable()
class Aws {
  final String accessKey;
  final String secretKey;
  Aws({
    required this.accessKey,
    required this.secretKey,
  });

  factory Aws.fromJson(Map<String, dynamic> json) => _$AwsFromJson(json);

  Map<String, dynamic> toJson() => _$AwsToJson(this);
}

@JsonSerializable()
class Advertise {
  final String image;
  final String link;

  Advertise({
    required this.image,
    required this.link,
  });

  factory Advertise.fromJson(Map<String, dynamic> json) =>
      _$AdvertiseFromJson(json);

  Map<String, dynamic> toJson() => _$AdvertiseToJson(this);
}

@JsonSerializable()
class InMemoryOf {
  final String title;
  final String name;
  final String description;
  final String more;
  final String image;
  InMemoryOf({
    required this.title,
    required this.name,
    required this.description,
    required this.more,
    required this.image,
  });

  factory InMemoryOf.fromJson(Map<String, dynamic> json) =>
      _$InMemoryOfFromJson(json);

  Map<String, dynamic> toJson() => _$InMemoryOfToJson(this);
}
