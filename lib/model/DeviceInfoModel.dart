class DeviceInfoModel {
  final String deviceType;
  final String deviceId;
  final String deviceName;
  final String deviceOSVersion;
  final String deviceIPAddress;
  final double latitude;
  final double longitude;
  final String buyerGcmId;
  final String buyerPemId;
  final AppInfo appInfo;

  DeviceInfoModel({
    required this.deviceType,
    required this.deviceId,
    required this.deviceName,
    required this.deviceOSVersion,
    required this.deviceIPAddress,
    required this.latitude,
    required this.longitude,
    required this.buyerGcmId,
    required this.buyerPemId,
    required this.appInfo,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      "deviceType": deviceType,
      "deviceId": deviceId,
      "deviceName": deviceName,
      "deviceOSVersion": deviceOSVersion,
      "deviceIPAddress": deviceIPAddress,
      "lat": latitude,
      "long": longitude,
      "buyer_gcmid": buyerGcmId,
      "buyer_pemid": buyerPemId,
      "app": appInfo.toJson(),
    };
  }
}

class AppInfo {
  final String version;
  final String installTimeStamp;
  final String uninstallTimeStamp;
  final String downloadTimeStamp;

  AppInfo({
    required this.version,
    required this.installTimeStamp,
    required this.uninstallTimeStamp,
    required this.downloadTimeStamp,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      "version": version,
      "installTimeStamp": installTimeStamp,
      "uninstallTimeStamp": uninstallTimeStamp,
      "downloadTimeStamp": downloadTimeStamp,
    };
  }
}
