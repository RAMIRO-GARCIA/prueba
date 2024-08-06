class Nap {
  final int id;
  final String organizationName;
  final int zoneId;
  final String zoneName;

  Nap({
    required this.id,
    required this.organizationName,
    required this.zoneId,
    required this.zoneName,
  });

  factory Nap.fromJson(Map<String, dynamic> json) {
    return Nap(
      id: json['id'] ?? 0,
      organizationName: json['organizationname'] ?? '',
      zoneId: json['zone_id'] ?? 0,
      zoneName: json['zone_name'] ?? '',
    );
  }
}
