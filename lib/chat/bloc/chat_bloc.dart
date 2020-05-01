import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mpmc/chat/chat_utils.dart';
import 'package:mpmc/enums/file_upload_enum.dart';
import 'package:mpmc/models/message_model.dart';
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
      Message message = Message(
          message: event.message,
          receiverId: event.receiver.id,
          senderId: event.sender.id,
          dateTime: DateTime.now());
      await chat.sendAmessage(event.sender, event.receiver, message);
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

    if (event is SendImage) {
      yield UploadProcess(uploadStatus: FileUpload.PROCESSING_UPLOAD);
      await chat.uploadImage(event.file, event.recipient);
      yield UploadProcess(uploadStatus: FileUpload.COMPLETE_UPLOAD);
    }
  }
}
