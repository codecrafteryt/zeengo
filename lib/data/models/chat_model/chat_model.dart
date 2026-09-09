import '../api_response_model.dart';

/// `GET/POST /chat/...` conversation row.
class ChatConversation extends Serializable {
  String? id;
  String? type;
  String? bookingId;
  String? title;
  String? createdAt;
  String? lastMessageAt;
  int? unreadCount;
  String? znCode;
  String? clientName;

  ChatConversation({
    this.id,
    this.type,
    this.bookingId,
    this.title,
    this.createdAt,
    this.lastMessageAt,
    this.unreadCount,
    this.znCode,
    this.clientName,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) =>
      ChatConversation(
        id: json['id']?.toString(),
        type: json['type']?.toString(),
        bookingId: json['bookingId']?.toString(),
        title: json['title']?.toString(),
        createdAt: json['createdAt']?.toString(),
        lastMessageAt: json['lastMessageAt']?.toString(),
        unreadCount: _asInt(json['unreadCount']),
        znCode: json['znCode']?.toString(),
        clientName: json['clientName']?.toString(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'bookingId': bookingId,
        'title': title,
        'createdAt': createdAt,
        'lastMessageAt': lastMessageAt,
        'unreadCount': unreadCount,
        'znCode': znCode,
        'clientName': clientName,
      };

  static int? _asInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    return null;
  }
}

/// Canonical chat message from REST / Socket.IO.
class ChatApiMessage extends Serializable {
  String? id;
  String? conversationId;
  String? senderType;

  /// Staff role when [senderType] is `staff`: admin | ops_manager | splizer | support | driver.
  String? senderRole;
  String? senderStaffId;
  String? senderClientId;
  String? senderName;
  String? body;
  Map<String, String>? bodyTranslated;
  String? sourceLang;
  List<dynamic>? attachments;
  String? createdAt;

  ChatApiMessage({
    this.id,
    this.conversationId,
    this.senderType,
    this.senderRole,
    this.senderStaffId,
    this.senderClientId,
    this.senderName,
    this.body,
    this.bodyTranslated,
    this.sourceLang,
    this.attachments,
    this.createdAt,
  });

  factory ChatApiMessage.fromJson(Map<String, dynamic> json) {
    Map<String, String>? translated;
    final raw = json['bodyTranslated'];
    if (raw is Map) {
      translated = raw.map(
        (k, v) => MapEntry(k.toString(), v?.toString() ?? ''),
      );
    }
    return ChatApiMessage(
      id: json['id']?.toString(),
      conversationId: json['conversationId']?.toString(),
      senderType: json['senderType']?.toString(),
      senderRole: (json['senderRole'] ?? json['sendType'])?.toString(),
      senderStaffId: json['senderStaffId']?.toString(),
      senderClientId: json['senderClientId']?.toString(),
      senderName: json['senderName']?.toString(),
      body: json['body']?.toString(),
      bodyTranslated: translated,
      sourceLang: json['sourceLang']?.toString(),
      attachments: json['attachments'] is List
          ? List<dynamic>.from(json['attachments'] as List)
          : null,
      createdAt: json['createdAt']?.toString(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'conversationId': conversationId,
        'senderType': senderType,
        'senderRole': senderRole,
        'senderStaffId': senderStaffId,
        'senderClientId': senderClientId,
        'senderName': senderName,
        'body': body,
        'bodyTranslated': bodyTranslated,
        'sourceLang': sourceLang,
        'attachments': attachments,
        'createdAt': createdAt,
      };

  bool isMine(String? myClientId) =>
      senderType == 'client' &&
      myClientId != null &&
      myClientId.isNotEmpty &&
      senderClientId == myClientId;

  /// Support / Driver / Splizer inbox tabs (0 / 1 / 2).
  bool matchesInboxTab(int tab) {
    final channel = inboxChannel;
    if (tab == 1) return channel == 'driver';
    if (tab == 2) return channel == 'splizer';
    return channel == 'admin';
  }

  /// Normalized channel: admin | driver | splizer.
  String get inboxChannel => channelForRole(senderRole);

  /// Map staff [role] from messages / `chat.typing` to inbox channel.
  static String channelForRole(String? role) {
    switch ((role ?? '').toLowerCase()) {
      case 'driver':
        return 'driver';
      case 'splizer':
        return 'splizer';
      default:
        // admin | support | ops_manager | null → Support tab
        return 'admin';
    }
  }

  static String roleForTab(int tab) {
    if (tab == 1) return 'driver';
    if (tab == 2) return 'splizer';
    return 'admin';
  }

  String roleLabel({
    required String support,
    required String driver,
    required String splizer,
  }) {
    switch (inboxChannel) {
      case 'driver':
        return driver;
      case 'splizer':
        return splizer;
      default:
        return support;
    }
  }

  /// Prefer API [senderName] (e.g. "Zeengo Admin"); else role label.
  String inboundLabel({
    required String support,
    required String driver,
    required String splizer,
  }) {
    final name = senderName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return roleLabel(support: support, driver: driver, splizer: splizer);
  }

  String displayText(String lang) {
    final t = bodyTranslated?[lang];
    if (t != null && t.trim().isNotEmpty) return t.trim();
    return body?.trim() ?? '';
  }

  String get timeLabel {
    final raw = createdAt;
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  static List<ChatApiMessage> listFrom(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => ChatApiMessage.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
