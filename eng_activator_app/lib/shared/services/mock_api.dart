import 'package:eng_activator_app/models/activity_response/activity_response.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_review.dart';
import 'package:eng_activator_app/models/activity_response/picture_activity_response.dart';
import 'package:eng_activator_app/models/activity_response/question_activity_response.dart';
import 'package:eng_activator_app/models/user.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/services/storage.dart';

class MockApi {
  final AppStorage _appStorage = Injector.get<AppStorage>();

  Future<List<ActivityResponse>> getActivityResponses() {
    var qa = _appStorage.getRandomQuestionActivity();
    var pa = _appStorage.getRandomPictureActivity();

    var res = [
      QuestionActivityResponse(
        answer: 'Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. Boisterous estimating interested collecting get conviction friendship say boy. Him mrs shy article smiling respect opinion excited. Welcomed humoured rejoiced peculiar to in an.Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. ',
        activity: qa,
        reviews: [],
        createdDate: DateTime.now(),
        createdBy: User(name: 'User Name', id: 1),
      ),
      PictureActivityResponse(
        answer: 'Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. Boisterous estimating interested collecting get conviction friendship say boy. Him mrs shy article smiling respect opinion excited. Welcomed humoured rejoiced peculiar to in an.Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. ',
        activity: pa,
        reviews: [],
        createdDate: DateTime.now(),
        createdBy: User(name: 'User Name', id: 1),
      ),
      QuestionActivityResponse(
        answer:
            """Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. Boisterous estimating interested collecting get conviction friendship say boy. Him mrs shy article smiling respect opinion excited. Welcomed humoured rejoiced peculiar to in an.Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. """,
        activity: qa,
        reviews: [],
        createdDate: DateTime.now(),
        createdBy: User(name: 'User Name', id: 2),
      ),
      PictureActivityResponse(
        answer: 'Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. Boisterous estimating interested collecting get conviction friendship say boy. Him mrs shy article smiling respect opinion excited. Welcomed humoured rejoiced peculiar to in an.Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. ',
        activity: pa,
        reviews: [],
        createdDate: DateTime.now(),
        createdBy: User(name: 'User Name', id: 2),
      ),
      QuestionActivityResponse(
        answer: 'Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. Boisterous estimating interested collecting get conviction friendship say boy. Him mrs shy article smiling respect opinion excited. Welcomed humoured rejoiced peculiar to in an.Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. ',
        activity: qa,
        reviews: [],
        createdDate: DateTime.now(),
        createdBy: User(name: 'User Name', id: 3),
      ),
      PictureActivityResponse(
        answer: 'Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. Boisterous estimating interested collecting get conviction friendship say boy. Him mrs shy article smiling respect opinion excited. Welcomed humoured rejoiced peculiar to in an.Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. ',
        activity: pa,
        reviews: [],
        createdDate: DateTime.now(),
        createdBy: User(name: 'User Name', id: 3),
      ),
      PictureActivityResponse(
        answer: 'Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. Boisterous estimating interested collecting get conviction friendship say boy. Him mrs shy article smiling respect opinion excited. Welcomed humoured rejoiced peculiar to in an.Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. ',
        activity: pa,
        reviews: [],
        createdDate: DateTime.now(),
        createdBy: User(name: 'User Name', id: 3),
      ),
      QuestionActivityResponse(
        answer: 'Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. Boisterous estimating interested collecting get conviction friendship say boy. Him mrs shy article smiling respect opinion excited. Welcomed humoured rejoiced peculiar to in an.Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. ',
        activity: qa,
        reviews: [],
        createdDate: DateTime.now(),
        createdBy: User(name: 'User Name', id: 3),
      ),
      PictureActivityResponse(
        answer: 'Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. Boisterous estimating interested collecting get conviction friendship say boy. Him mrs shy article smiling respect opinion excited. Welcomed humoured rejoiced peculiar to in an.Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. ',
        activity: pa,
        reviews: [],
        createdDate: DateTime.now(),
        createdBy: User(name: 'User Name', id: 3),
      ),
    ];

    return Future.delayed(Duration(milliseconds: 1000), () {
      return res;
    });
  }

  Future<List<ActivityResponseReview>> getActivityReviews() {
    var res = [
      ActivityResponseReview(
        text:
            "some answer here answer words sdf sdfdfd dfdfdfd wer  a lot of words sf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... kmsf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... ksf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... km sf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... kmsf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... kmsf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... kmsf sdfsdf sdfsdf sdfsdfsdf fffffffs  ssssdf fffffff",
        score: 4.5,
        createdBy: User(name: 'Name Name', id: 3),
        createdDate: DateTime.now(),
        isViewed: false,
        id: 1,
      ),
      ActivityResponseReview(
        text:
            "some answer here answer words sdf sdfdfd dfdfdfd wer  a lot of words sf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... kmsf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... ksf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... km sf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... kmsf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... kmsf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... kmsf sdfsdf sdfsdf sdfsdfsdf fffffffs  ssssdf fffffff",
        score: 4.5,
        createdBy: User(name: 'Name Name', id: 3),
        createdDate: DateTime.now(),
        isViewed: false,
        id: 1,
      ),
      ActivityResponseReview(
        text:
            "some answer here answer words sdf sdfdfd dfdfdfd wer  a lot of words sf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... kmsf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... ksf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... km sf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... kmsf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... kmsf sdfsdf sdfsdf sdfsdfsdf fffffffs  sssss sssdp089 sdfsdlmn mlkml ... kmsf sdfsdf sdfsdf sdfsdfsdf fffffffs  ssssdf fffffff",
        score: 4.5,
        createdBy: User(name: 'Name Name', id: 3),
        createdDate: DateTime.now(),
        isViewed: false,
        id: 1,
      ),
    ];

    return Future.delayed(Duration(milliseconds: 1000), () {
      return res;
    });
  }
}
