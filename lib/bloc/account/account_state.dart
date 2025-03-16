part of 'account_bloc.dart';

abstract class AccountState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final String profileImage;
  final String birthday;
  final String gender;
  final int weight;
  final int height;
  final String unit;
  final String unitHeight;

  AccountLoaded({
    required this.profileImage,
    required this.birthday,
    required this.gender,
    required this.weight,
    required this.height,
    required this.unit,
    required this.unitHeight,
  });

  @override
  List<Object?> get props => [
    profileImage,
    birthday,
    gender,
    weight,
    height,
    unit,
    unitHeight,
  ];
}

class AccountError extends AccountState {
  final String message;
  AccountError(this.message);

  @override
  List<Object?> get props => [message];
}
