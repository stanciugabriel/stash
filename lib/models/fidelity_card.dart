import 'package:Stash/utils/gen.dart';

class UpdateFidelityCard {
  String id;
  String nickname;

  UpdateFidelityCard({
    required this.id,
    required this.nickname,
  });

  factory UpdateFidelityCard.fromEmpty() {
    return UpdateFidelityCard(id: '', nickname: '');
  }

  factory UpdateFidelityCard.fromJSON(Map<String, dynamic> json) {
    return UpdateFidelityCard(
        id: json['id'] ?? '', nickname: json['nickname'] ?? '');
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'nickname': nickname,
    };
  }
}

class FidelityCard {
  String id;
  String accountID;

  String code;
  String format;

  String storeID;
  String nickname;

  FidelityCard({
    required this.id,
    required this.accountID,
    required this.code,
    required this.format,
    required this.storeID,
    required this.nickname,
  });

  factory FidelityCard.fromEmpty() {
    return FidelityCard(
      id: '',
      accountID: '',
      code: '',
      format: '',
      storeID: '',
      nickname: '',
    );
  }

  factory FidelityCard.init(String accountID) {
    final fc = FidelityCard.fromEmpty();
    fc.accountID = accountID;
    fc.id = genID(20);

    return fc;
  }

  factory FidelityCard.fromJSON(Map<String, String> json) {
    return FidelityCard(
      id: json['id'] ?? '',
      accountID: json['accountID'] ?? '',
      code: json['code'] ?? '',
      format: json['format'] ?? '',
      storeID: json['storeID'] ?? '',
      nickname: json['nickname'] ?? '',
    );
  }

  Map<String, String> toJSON() {
    return {
      'id': id,
      'accountID': accountID,
      'code': code,
      'format': format,
      'storeID': storeID,
      'nickname': nickname,
    };
  }
}
