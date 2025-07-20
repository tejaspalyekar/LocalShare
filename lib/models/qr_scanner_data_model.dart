class QrScannerDataModel {
  String remoteIpAddress;
  String remoteDeviceName;
  int remotePortNumber;

  QrScannerDataModel({
    required this.remoteIpAddress,
    required this.remoteDeviceName,
    required this.remotePortNumber,
  });

  factory QrScannerDataModel.fromJson(Map<String, dynamic> json) {
    return QrScannerDataModel(
      remoteIpAddress: json['remoteIpAddress'] ?? '',
      remoteDeviceName: json['remoteDeviceName'] ?? '',
      remotePortNumber: json['remotePortNumber'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'remoteIpAddress': remoteIpAddress,
      'remoteDeviceName': remoteDeviceName,
      'remotePortNumber': remotePortNumber,
    };
  }
}
