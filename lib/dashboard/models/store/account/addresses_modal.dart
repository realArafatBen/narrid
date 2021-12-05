class AddressModal {
  final first_name;
  final last_name;
  final line1;
  final line2;
  final address;
  final city;
  final region;
  final default_;
  final id;
  final alias;
  final state;

  AddressModal(
      {this.first_name,
      this.last_name,
      this.line1,
      this.line2,
      this.address,
      this.city,
      this.region,
      this.default_,
      this.id,
      this.alias,
      this.state});

  factory AddressModal.fromJson(Map<String, dynamic> json) {
    final first_name = json['first_name'];
    final last_name = json['last_name'];
    final line1 = json['line1'];
    final line2 = json['line2'];
    final address = json['address'];
    final city = json['city'];
    final region = json['region'];
    final default_ = json['default'];
    final id = json['id'];

    return AddressModal(
        first_name: first_name,
        last_name: last_name,
        line1: line1,
        line2: line2,
        address: address,
        city: city,
        region: region,
        default_: default_,
        id: id);
  }

  factory AddressModal.fromJsonCity(Map<String, dynamic> json) {
    final state = json['state'];
    final alias = json['alias'];
    return AddressModal(state: state, alias: alias);
  }
}
