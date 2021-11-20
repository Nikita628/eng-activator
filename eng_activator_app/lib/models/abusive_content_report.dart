class AbusiveContentReport {
  late String report;

  AbusiveContentReport({
    required String report,
  }) {
    this.report = report;
  }

  Map<String, dynamic> toJson() {
    return {
      "report": this.report,
    };
  }
}
