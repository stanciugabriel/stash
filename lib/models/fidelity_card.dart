class FidelityCard {
  String id;

  String code;
  String format;

  String storeID;
  String nickname;

  FidelityCard({
    required this.id,
    required this.code,
    required this.format,
    required this.storeID,
    required this.nickname,
  });

  factory FidelityCard.fromEmpty() {
    return FidelityCard(
      id: '',
      code: '',
      format: '',
      storeID: '',
      nickname: '',
    );
  }

  factory FidelityCard.fromJSON(Map<String, String> json) {
    return FidelityCard(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      format: json['format'] ?? '',
      storeID: json['storeID'] ?? '',
      nickname: json['nickname'] ?? '',
    );
  }

  Map<String, String> toJSON() {
    return {
      'id': id,
      'code': code,
      'format': format,
      'storeID': storeID,
      'nickname': nickname,
    };
  }
}
