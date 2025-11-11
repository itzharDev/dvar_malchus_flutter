// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DvarMalchusConfig _$DvarMalchusConfigFromJson(Map<String, dynamic> json) =>
    DvarMalchusConfig(
      aws: Aws.fromJson(json['aws'] as Map<String, dynamic>),
      inMemoryOf:
          InMemoryOf.fromJson(json['inMemoryOf'] as Map<String, dynamic>),
      advertise: json['advertise'] == null
          ? null
          : Advertise.fromJson(json['advertise'] as Map<String, dynamic>),
      coverImage: json['coverImage'] as String,
      ios: json['ios'] as String,
      android: json['android'] as String,
      hebDate: json['hebDate'] as String,
      currentMonthDays: (json['currentMonthDays'] as num).toInt(),
      lastMonthDays: (json['lastMonthDays'] as num).toInt(),
      nextMonthDays: (json['nextMonthDays'] as num).toInt(),
      isLeapYear: json['isLeapYear'] as bool,
    );

Map<String, dynamic> _$DvarMalchusConfigToJson(DvarMalchusConfig instance) =>
    <String, dynamic>{
      'aws': instance.aws,
      'inMemoryOf': instance.inMemoryOf,
      'advertise': instance.advertise,
      'coverImage': instance.coverImage,
      'ios': instance.ios,
      'android': instance.android,
      'hebDate': instance.hebDate,
      'currentMonthDays': instance.currentMonthDays,
      'lastMonthDays': instance.lastMonthDays,
      'nextMonthDays': instance.nextMonthDays,
      'isLeapYear': instance.isLeapYear,
    };

Aws _$AwsFromJson(Map<String, dynamic> json) => Aws(
      accessKey: json['accessKey'] as String,
      secretKey: json['secretKey'] as String,
    );

Map<String, dynamic> _$AwsToJson(Aws instance) => <String, dynamic>{
      'accessKey': instance.accessKey,
      'secretKey': instance.secretKey,
    };

Advertise _$AdvertiseFromJson(Map<String, dynamic> json) => Advertise(
      image: json['image'] as String,
      link: json['link'] as String,
    );

Map<String, dynamic> _$AdvertiseToJson(Advertise instance) => <String, dynamic>{
      'image': instance.image,
      'link': instance.link,
    };

InMemoryOf _$InMemoryOfFromJson(Map<String, dynamic> json) => InMemoryOf(
      title: json['title'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      more: json['more'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$InMemoryOfToJson(InMemoryOf instance) =>
    <String, dynamic>{
      'title': instance.title,
      'name': instance.name,
      'description': instance.description,
      'more': instance.more,
      'image': instance.image,
    };
