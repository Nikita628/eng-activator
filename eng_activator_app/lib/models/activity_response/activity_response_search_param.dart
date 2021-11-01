import 'package:eng_activator_app/models/api_page_request.dart';

class ActivityResponseSearchParam extends ApiPageRequest {
  late DateTime? createdDateEquals;
  late DateTime? lastUpdatedDateLessThan;

  ActivityResponseSearchParam({
    DateTime? createdDateEquals,
    DateTime? lastUpdatedDateLessThan,
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
          this.createdDateEquals = createdDateEquals;
          this.lastUpdatedDateLessThan = lastUpdatedDateLessThan;
        }

  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "createdDateEquals": createdDateEquals?.toIso8601String(),
      "lastUpdatedDateLessThan": lastUpdatedDateLessThan?.toIso8601String(),
    };
  }
}
