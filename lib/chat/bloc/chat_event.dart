import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChatEvent extends Equatable {
  ChatEvent([List props = const <dynamic>[]]) : super(props);
}

class SendMessage extends ChatEvent {
  final bool isNew;
  final String sender, message, recipient, token;
  SendMessage(
      {this.isNew = false,
      @required this.sender,
      @required this.message,
      @required this.recipient,
      this.token})
      : super([isNew, sender, message, recipient, token]);
}

class StartNewChat extends ChatEvent {
  final bool isNew;
  final String sender, message, recipient, token;
  StartNewChat(
      {this.isNew = true,
      @required this.sender,
      @required this.message,
      @required this.recipient,
      this.token})
      : super([isNew, sender, message, recipient, token]);
}

class CheckNotifications extends ChatEvent {
  final String from;
  CheckNotifications({@required this.from}) : super([from]);
}

class TypingMessage extends ChatEvent {
  final bool isTyping;

  TypingMessage({this.isTyping = false}) : super([isTyping]);
}

class SendImage extends ChatEvent {
  final File file;
  final String recipient;

  SendImage({@required this.file, @required this.recipient})
      : super([file, recipient]);
}
