class SaveRequest {
  int id;
  String url;
  String body;
  String requestType;

  SaveRequest({this.id, this.url, this.body, this.requestType});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['body'] = this.body;
    data['requestType'] = this.requestType;
    return data;
  }

  factory SaveRequest.fromString(Map<String, dynamic> json) {
    return SaveRequest(
      id: json['id'],
      url: json['url'],
      body: json['body'],
      requestType: json['requestType'],
    );
  }
}
