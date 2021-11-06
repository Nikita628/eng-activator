import 'package:eng_activator_app/models/api/api_keyset_page_request.dart';

class ActivityResponseReviewSearchParam extends KeysetPageRequest {
  late int activityResponseIdEquals;
  late DateTime? createdDateLessThan;

  ActivityResponseReviewSearchParam({
    required int activityResponseId,
    DateTime? createdDateLessThan,
    int pageSize = 10,
  }) : super(
          pageSize: pageSize,
        ) {
    this.activityResponseIdEquals = activityResponseId;
    this.createdDateLessThan = createdDateLessThan;
  }

  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "activityResponseIdEquals": activityResponseIdEquals,
      "createdDateLessThan": createdDateLessThan?.toIso8601String(),
    };
  }
}
