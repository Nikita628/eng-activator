import 'package:eng_activator_app/models/activity/activity.dart';
import '../word_entry.dart';

class PictureActivity extends Activity {
  late String picUrl;

  PictureActivity(String picUrl, List<WordEntry> wordEntries)
      : super(wordEntries) {
    this.picUrl = picUrl;
  }

  Map<String, dynamic> toJson() {
    return {
      "picUrl": picUrl,
      ...super.toJson(),
    };
  }

  PictureActivity.fromJson(Map<String, dynamic> json): super.fromJson(json) {
    picUrl = json["picUrl"] ?? "";
  }
}
