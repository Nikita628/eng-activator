import 'package:eng_activator_app/models/api_page_request.dart';

class ActivityResponseReviewSearchParam extends ApiPageRequest {
late int activityResponseIdEquals;

  ActivityResponseReviewSearchParam({
    required int activityResponseId,
    int pageNumber = 1,
    int pageSize = 10,
    String sortDirection = "asc",
    String sortProp = "id",
  }) : super(
          pageNumber: pageNumber,
          pageSize: pageSize,
          sortDirection: sortDirection,
          sortProp: sortProp,
        ) {
          this.activityResponseIdEquals = activityResponseId;
        }

  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "activityResponseIdEquals": activityResponseIdEquals,
    };
  }
}