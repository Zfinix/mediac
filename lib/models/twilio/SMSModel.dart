class SMSModel {
  String accountSid;
  String apiVersion;
  String body;
  String dateCreated;
  String dateSent;
  String dateUpdated;
  String direction;
  var errorCode;
  var errorMessage;
  String from;
  String messagingServiceSid;
  String numMedia;
  String numSegments;
  String price;
  String priceUnit;
  String sid;
  String status;
  SubresourceUris subresourceUris;
  String to;
  String uri;

  SMSModel(
      {this.accountSid,
      this.apiVersion,
      this.body,
      this.dateCreated,
      this.dateSent,
      this.dateUpdated,
      this.direction,
      this.errorCode,
      this.errorMessage,
      this.from,
      this.messagingServiceSid,
      this.numMedia,
      this.numSegments,
      this.price,
      this.priceUnit,
      this.sid,
      this.status,
      this.subresourceUris,
      this.to,
      this.uri});

  SMSModel.fromJson(Map<String, dynamic> json) {
    accountSid = json['account_sid'];
    apiVersion = json['api_version'];
    body = json['body'];
    dateCreated = json['date_created'];
    dateSent = json['date_sent'];
    dateUpdated = json['date_updated'];
    direction = json['direction'];
    errorCode = json['error_code'];
    errorMessage = json['error_message'];
    from = json['from'];
    messagingServiceSid = json['messaging_service_sid'];
    numMedia = json['num_media'];
    numSegments = json['num_segments'];
    price = json['price'];
    priceUnit = json['price_unit'];
    sid = json['sid'];
    status = json['status'];
    subresourceUris = json['subresource_uris'] != null
        ? new SubresourceUris.fromJson(json['subresource_uris'])
        : null;
    to = json['to'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_sid'] = this.accountSid;
    data['api_version'] = this.apiVersion;
    data['body'] = this.body;
    data['date_created'] = this.dateCreated;
    data['date_sent'] = this.dateSent;
    data['date_updated'] = this.dateUpdated;
    data['direction'] = this.direction;
    data['error_code'] = this.errorCode;
    data['error_message'] = this.errorMessage;
    data['from'] = this.from;
    data['messaging_service_sid'] = this.messagingServiceSid;
    data['num_media'] = this.numMedia;
    data['num_segments'] = this.numSegments;
    data['price'] = this.price;
    data['price_unit'] = this.priceUnit;
    data['sid'] = this.sid;
    data['status'] = this.status;
    if (this.subresourceUris != null) {
      data['subresource_uris'] = this.subresourceUris.toJson();
    }
    data['to'] = this.to;
    data['uri'] = this.uri;
    return data;
  }
}

class SubresourceUris {
  String media;

  SubresourceUris({this.media});

  SubresourceUris.fromJson(Map<String, dynamic> json) {
    media = json['media'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['media'] = this.media;
    return data;
  }
}