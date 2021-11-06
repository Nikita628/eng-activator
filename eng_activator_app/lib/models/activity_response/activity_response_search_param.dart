import 'package:eng_activator_app/models/api/api_keyset_page_request.dart';

class ActivityResponseSearchParam extends KeysetPageRequest {
  late DateTime? createdDateEquals;
  late DateTime? lastUpdatedDateLessThan;

  ActivityResponseSearchParam({
    DateTime? createdDateEquals,
    DateTime? lastUpdatedDateLessThan,
    int pageSize = 10,
  }) : super(
          pageSize: pageSize,
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
