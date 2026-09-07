import 'dart:convert';

class SendJournalMessageModel {
  bool? success;
  String? message;
  MessageData? data;

  SendJournalMessageModel({
    this.success,
    this.message,
    this.data,
  });

  factory SendJournalMessageModel.fromRawJson(String str) =>
      SendJournalMessageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SendJournalMessageModel.fromJson(Map<String, dynamic> json) =>
      SendJournalMessageModel(
        success: json["success"],
        message: json["message"]?.toString(),
        data: json["data"] == null ? null : MessageData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class MessageData {
  ChatMessage? userMessage;
  ChatMessage? aiMessage;
  List<ChatMessage>? messages;

  MessageData({
    this.userMessage,
    this.aiMessage,
    this.messages,
  });

  factory MessageData.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      ChatMessage? userMsg;
      if (json["user_message"] is Map<String, dynamic>) {
        userMsg = ChatMessage.fromJson(json["user_message"]);
      } else if (json["user"] is Map<String, dynamic>) {
        userMsg = ChatMessage.fromJson(json["user"]);
      }

      ChatMessage? aiMsg;
      if (json["ai_message"] is Map<String, dynamic>) {
        aiMsg = ChatMessage.fromJson(json["ai_message"]);
      } else if (json["ai"] is Map<String, dynamic>) {
        aiMsg = ChatMessage.fromJson(json["ai"]);
      } else if (json["ai_response"] is Map<String, dynamic>) {
        aiMsg = ChatMessage.fromJson(json["ai_response"]);
      } else if (json["reply"] is Map<String, dynamic>) {
        aiMsg = ChatMessage.fromJson(json["reply"]);
      } else if (json["ai_message"] is String) {
        aiMsg = ChatMessage(sender: "ai", message: json["ai_message"]);
      } else if (json["reply"] is String) {
        aiMsg = ChatMessage(sender: "ai", message: json["reply"]);
      } else if (json["message"] is String && userMsg != null) {
        aiMsg = ChatMessage(sender: "ai", message: json["message"]);
      }

      List<ChatMessage>? msgList;
      if (json["messages"] is List) {
        msgList = (json["messages"] as List)
            .map((e) => ChatMessage.fromJson(e))
            .toList();
      }

      return MessageData(
        userMessage: userMsg,
        aiMessage: aiMsg,
        messages: msgList,
      );
    }
    return MessageData();
  }

  Map<String, dynamic> toJson() => {
    "user_message": userMessage?.toJson(),
    "ai_message": aiMessage?.toJson(),
    "messages": messages?.map((x) => x.toJson()).toList(),
  };
}

class ChatMessage {
  int? id;
  int? journalEntryId;
  String? sender;
  String? message;
  DateTime? createdAt;
  DateTime? updatedAt;

  ChatMessage({
    this.id,
    this.journalEntryId,
    this.sender,
    this.message,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatMessage.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return ChatMessage(message: json?.toString());
    }
    return ChatMessage(
      id: json["id"] is int ? json["id"] : int.tryParse(json["id"]?.toString() ?? ''),
      journalEntryId: json["journal_entry_id"] ?? json["journalId"],
      sender: json["sender"]?.toString() ?? (json["role"]?.toString() == "user" ? "user" : "ai"),
      message: json["message"]?.toString() ??
          json["content"]?.toString() ??
          json["text"]?.toString() ??
          json["response"]?.toString() ??
          '',
      createdAt:
          json["created_at"] == null
              ? null
              : DateTime.tryParse(json["created_at"].toString()),
      updatedAt:
          json["updated_at"] == null
              ? null
              : DateTime.tryParse(json["updated_at"].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "journal_entry_id": journalEntryId,
    "sender": sender,
    "message": message,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
