class EntityResponse<T> {
  int code;
  String message;
  T data;
  bool success;

  EntityResponse({this.code, this.message, this.data, this.success});

  EntityResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? json['Code'];
    message = json['message'] ?? json['Message'];
    data = json['data'] ?? json['Data'];
    success = json['success'] ?? json['Success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['data'] = this.data;
    data['success'] = this.success;
    return data;
  }
}
