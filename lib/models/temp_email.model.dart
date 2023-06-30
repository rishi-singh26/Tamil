class TempEmail {
  final String id;
  final String address;
  final String password;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final bool isDisabled;
  final int quota;
  final int used;

  TempEmail({
    required this.address,
    required this.id,
    required this.password,
    required this.createdAt,
    required this.isDeleted,
    required this.isDisabled,
    required this.quota,
    required this.updatedAt,
    required this.used,
  });

  TempEmail.initial()
      : address = '',
        id = '',
        password = '',
        createdAt = DateTime.now(),
        isDeleted = true,
        isDisabled = true,
        quota = 0,
        updatedAt = DateTime.now(),
        used = 0;

  TempEmail.fromJson(Map<String, dynamic> json)
      : address = json.containsKey('address') ? json['address'] : '',
        id = json.containsKey('id') ? json['id'] : '',
        password = json.containsKey('password') ? json['password'] : '',
        createdAt = json.containsKey('createdAt') ? DateTime.parse(json['createdAt']) : DateTime.now(),
        isDeleted = json.containsKey('isDeleted') ? json['isDeleted'] : true,
        isDisabled = json.containsKey('isDisabled') ? json['isDisabled'] : true,
        quota = json.containsKey('quota') ? json['quota'] : 0,
        updatedAt = json.containsKey('updatedAt') ? DateTime.parse(json['updatedAt']) : DateTime.now(),
        used = json.containsKey('used') ? json['used'] : 0;

  Map<String, dynamic> toJson() => {
        'address': address,
        'id': id,
        'password': password,
        'createdAt': createdAt.toIso8601String(),
        'isDeleted': isDeleted,
        'isDisabled': isDisabled,
        'quota': quota,
        'updatedAt': updatedAt.toIso8601String(),
        'used': used
      };
}
