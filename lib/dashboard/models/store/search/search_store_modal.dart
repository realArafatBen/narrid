import 'package:flutter/cupertino.dart';

class SearchModal {
  final name;

  SearchModal({@required this.name});

  factory SearchModal.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    return SearchModal(name: name);
  }
}
