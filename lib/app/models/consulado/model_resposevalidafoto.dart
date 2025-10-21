class PhotoUploadResponse {
  final String status;
  final String codProcess;

  PhotoUploadResponse({
    required this.status,
    required this.codProcess,
  });

  factory PhotoUploadResponse.fromJson(Map<String, dynamic> json) {
    return PhotoUploadResponse(
      status: json['status'] as String,
      codProcess: json['codProcess'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'codProcess': codProcess,
    };
  }
}
