import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChatState extends Equatable {
  ChatState([List props = const <dynamic>[]]) : super(props);
}

class InitialChatState extends ChatState {}

class SendingMessage extends ChatState {
  final bool sending;

  SendingMessage({this.sending = true});
}

class ComposingMessage extends ChatState {
  final bool typing;

  ComposingMessage({this.typing = false});
}

class MessageSent extends ChatState {
  final bool status;
  final String msg;

  MessageSent({this.status = true, this.msg});
}

class NewNotification extends ChatState {
  final bool notifs;
  final int count;

  NewNotification({this.notifs = false, this.count = 0});
}
