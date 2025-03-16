part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAccountDetails extends AccountEvent {
  final String userId;

  FetchAccountDetails({required this.userId});

  @override
  List<Object?> get props => [userId];
}
