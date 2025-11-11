import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit() : super(AnalyticsInitial());

  logEvent(String eventName, {Map<String, Object>? params = const {}}) {
    FirebaseAnalytics.instance.logEvent(name: eventName, parameters: params);
  }
}
