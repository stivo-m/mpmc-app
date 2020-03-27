import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mpmc/chat/chat_utils.dart';
import './bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  @override
  ChatState get initialState => InitialChatState();

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is SendMessage) {
      yield SendingMessage(sending: true);
      await chat.sendMessage(event.recipient, event.message, event.token);
      yield MessageSent();
    }

    if (event is StartNewChat) {
      yield SendingMessage(sending: true);
      await chat.startNewChat(event.recipient, event.message, event.token);
      yield MessageSent();
    }

    if (event is TypingMessage) {
      //notify chat partner that chat user is typing
      print("Chat user is typing...");
    }

    if (event is CheckNotifications) {
      //chack notifications and yield a notification state with values
      yield NewNotification(count: 0, notifs: true);
      print("Notifications Checked");
    }

    if (event is SendImage) {
      yield SendingMessage(sending: true);
      String msg = '';
      bool success = true;
      print("started");
      await chat.uploadImage(event.file, event.recipient);
      print("complete");
      yield MessageSent(msg: msg, status: success);
    }
  }
}
