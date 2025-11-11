// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _RestClient implements RestClient {
  _RestClient(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://dvarmalchus.co.il/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<DvarMalchusConfig> getConfig() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<dynamic>(
      _setStreamType<DvarMalchusConfig>(
        Options(
          method: 'GET',
          headers: _headers,
          extra: _extra,
          // Here we leave the responseType as is, assuming it returns a String.
        )
            .compose(
              _dio.options,
              '/getConfigurations',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );

    // Convert the String response to a Map
    final Map<String, dynamic> dataMap = jsonDecode(_result.data as String);
    final value = DvarMalchusConfig.fromJson(dataMap);
    return value;
  }

  @override
  Future<Dvarmalchus> getDvarMalchus(Map<String, dynamic> map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);

    // Making the POST request without using _setStreamType
    var response;
    try {
      response = await _dio.post<dynamic>(
        '${baseUrl}getDvarMalchusILMembers',
        queryParameters: queryParameters,
        data: _data,
        options: Options(
          headers: _headers,
          extra: _extra,
        ),
      );
      var a = jsonDecode(response.data);
      print(a);
    } on Exception catch (e) {
      print('e');
      print(e);
    }
    // Parsing the response after it is received
    return Dvarmalchus.fromJson(jsonDecode(response.data)[0]);
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
