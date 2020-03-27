import 'package:equatable/equatable.dart';

abstract class FinanceEvent extends Equatable {
  const FinanceEvent();
}

class MPESATransaction extends FinanceEvent {
  final String description;
  final double amount;

  MPESATransaction({this.description, this.amount});
}
