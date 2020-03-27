import 'package:equatable/equatable.dart';

abstract class FinanceState extends Equatable {
  const FinanceState();
}

class InitialFinanceState extends FinanceState {
  @override
  List<Object> get props => [];
}

class ProcessingPayments extends FinanceState {
  final bool processing;
  ProcessingPayments({this.processing = true});
}

class TransactionFailed extends FinanceState {
  final bool success;
  final String error;
  final dynamic errorMessage;

  TransactionFailed({this.success = false, this.error, this.errorMessage});
}

class TransactionSuccess extends FinanceState {
  final bool success;
  final String message;
  final dynamic successMessage;

  TransactionSuccess({this.success = true, this.message, this.successMessage});
}
