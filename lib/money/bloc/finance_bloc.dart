import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mpmc/authentication/Utils.dart';
import './bloc.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  @override
  FinanceState get initialState => InitialFinanceState();

  @override
  Stream<FinanceState> mapEventToState(
    FinanceEvent event,
  ) async* {
    if (event is MPESATransaction) {
      bool success = false;
      String msg = "";
      dynamic successError;
      yield ProcessingPayments();
      await respository
          .payWithMpesa(event.description, event.amount)
          .then((feedback) {
        msg = "Wait for the MPESA USSD To confirm Payment";
        print("VAR: $feedback");
        successError = feedback;
        success = true;
      }).catchError((e) {
        success = false;
        msg = "Sorry, an Error Occured";
        successError = e;
      });

      yield success
          ? TransactionSuccess(message: msg, successMessage: successError)
          : TransactionFailed(error: msg, errorMessage: successError);
    }
  }
}
