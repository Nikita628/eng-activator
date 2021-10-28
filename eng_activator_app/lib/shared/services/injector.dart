import 'package:eng_activator_app/services/activity/activity_service.dart';
import 'package:eng_activator_app/services/activity/activity_validator.dart';
import 'package:eng_activator_app/services/api_clients/activity_response_api_client.dart';
import 'package:eng_activator_app/services/api_clients/activity_response_review_api_client.dart';
import 'package:eng_activator_app/services/api_clients/auth_api_client.dart';
import 'package:eng_activator_app/services/api_clients/dictionary_api_client.dart';
import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/services/auth/auth_validator.dart';
import 'package:eng_activator_app/shared/services/event_hub.dart';
import 'package:eng_activator_app/shared/services/mock_api.dart';
import 'package:eng_activator_app/shared/services/storage.dart';

class Injector {
  static final ActivityService _activityService = ActivityService();
  static final EventHub _eventHub = EventHub();
  static final MockApi _mockApi = MockApi();
  static final AppStorage _appStorage = AppStorage();
  static final AuthValidator _authValidator = AuthValidator();
  static final ActivityValidator _activityValidator = ActivityValidator();
  static final AppNavigator _appNavigator = AppNavigator();
  static final DictionaryApiClient _dictionaryApiClient = DictionaryApiClient();
  static final AuthApiClient _authApiClient = AuthApiClient();
  static final ActivityResponseApiClient _activityResponseApiClient = ActivityResponseApiClient();
  static final ActivityResponseReviewApiClient _activityResponseReviewApiClient = ActivityResponseReviewApiClient();

  static T get<T>() {
    Object? objectOfType;

    if (_typesEqual<T, ActivityService>()) {
      objectOfType = _activityService;
    } else if (_typesEqual<T, EventHub>()) {
      objectOfType = _eventHub;
    } else if (_typesEqual<T, MockApi>()) {
      objectOfType = _mockApi;
    } else if (_typesEqual<T, AppStorage>()) {
      objectOfType = _appStorage;
    } else if (_typesEqual<T, AuthValidator>()) {
      objectOfType = _authValidator;
    } else if (_typesEqual<T, ActivityValidator>()) {
      objectOfType = _activityValidator;
    } else if (_typesEqual<T, AppNavigator>()) {
      objectOfType = _appNavigator;
    } else if (_typesEqual<T, DictionaryApiClient>()) {
      objectOfType = _dictionaryApiClient;
    } else if (_typesEqual<T, AuthApiClient>()) {
      objectOfType = _authApiClient;
    } else if (_typesEqual<T, ActivityResponseApiClient>()) {
      objectOfType = _activityResponseApiClient;
    } else if (_typesEqual<T, ActivityResponseReviewApiClient>()) {
      objectOfType = _activityResponseReviewApiClient;
    }
    else {
      throw Exception('Type not found');
    }

    return objectOfType as T;
  }

  static _typesEqual<T1, T2>() {
    return T1 == T2;
  }
}
