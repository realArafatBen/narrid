part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterButtonPressed extends RegisterEvent {
  final String email;
  final String password;
  final String first_name;
  final String last_name;
  final String state;
  final String mobile;
  final String country;

  const RegisterButtonPressed({
    @required this.email,
    @required this.password,
    @required this.first_name,
    @required this.last_name,
    @required this.state,
    @required this.mobile,
    @required this.country,
  });

  @override
  List<Object> get props => [
        email,
        password,
        first_name,
        last_name,
        state,
        mobile,
        country,
      ];
}
