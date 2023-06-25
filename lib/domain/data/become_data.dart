class BecomeData {
  final String uid;
  final String name;
  final String whom;
  final String? link;
  final bool? status;

  BecomeData({
    required this.uid,
    required this.name,
    required this.whom,
    this.link,
    this.status,
  });

  factory BecomeData.fromMap({required Map<String, dynamic> map}) {
    return BecomeData(
      uid: map['uid'],
      name: map['name'],
      whom: map['whom'],
      link: map['link'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'whom': whom,
      'link': link,
      'status': status,
    };
  }

  BecomeData copyWith({
    String? uid,
    String? name,
    String? whom,
    String? link,
    bool? status,
  }) {
    return BecomeData(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      whom: whom ?? this.whom,
      link: link ?? this.link,
      status: status ?? this.status,
    );
  }
}