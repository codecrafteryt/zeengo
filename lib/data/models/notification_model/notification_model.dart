import '../api_response_model.dart';

class PaginationMeta {
  int? page;
  int? limit;
  int? total;

  PaginationMeta({this.page, this.limit, this.total});

  factory PaginationMeta.fromJson(Map<String, dynamic> json) => PaginationMeta(
        page: _asInt(json['page']),
        limit: _asInt(json['limit']),
        total: _asInt(json['total']),
      );

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
        'total': total,
      };

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}

/// Inbox notification row (`GET /notifications` item / `notification.new`).
class AppNotification extends Serializable {
  String? id;
  String? recipientType;
  String? staffId;
  String? clientId;
  String? type;
  String? title;
  String? body;
  Map<String, dynamic>? data;
  String? readAt;
  bool? isRead;
  String? createdAt;

  AppNotification({
    this.id,
    this.recipientType,
    this.staffId,
    this.clientId,
    this.type,
    this.title,
    this.body,
    this.data,
    this.readAt,
    this.isRead,
    this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id']?.toString(),
        recipientType: json['recipientType']?.toString(),
        staffId: json['staffId']?.toString(),
        clientId: json['clientId']?.toString(),
        type: json['type']?.toString(),
        title: json['title']?.toString(),
        body: json['body']?.toString(),
        data: json['data'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(json['data'] as Map)
            : (json['data'] is Map
                ? Map<String, dynamic>.from(json['data'] as Map)
                : null),
        readAt: json['readAt']?.toString(),
        isRead: json['isRead'] is bool ? json['isRead'] as bool : null,
        createdAt: json['createdAt']?.toString(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'recipientType': recipientType,
        'staffId': staffId,
        'clientId': clientId,
        'type': type,
        'title': title,
        'body': body,
        'data': data,
        'readAt': readAt,
        'isRead': isRead,
        'createdAt': createdAt,
      };

  bool get unread => isRead != true;
}

class NotificationListResult {
  final List<AppNotification> items;
  final PaginationMeta? meta;
  final bool success;
  final String error;

  NotificationListResult({
    required this.items,
    this.meta,
    this.success = true,
    this.error = '',
  });

  factory NotificationListResult.fromEnvelope(Map<String, dynamic> json) {
    final success = json['success'] == true;
    final raw = json['data'];
    final items = <AppNotification>[];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map<String, dynamic>) {
          items.add(AppNotification.fromJson(item));
        } else if (item is Map) {
          items.add(
            AppNotification.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    String errorMessage = '';
    final errorObj = json['error'];
    if (errorObj is Map) {
      errorMessage = errorObj['message']?.toString() ??
          errorObj['code']?.toString() ??
          '';
    } else if (errorObj is String) {
      errorMessage = errorObj;
    }

    return NotificationListResult(
      items: items,
      meta: json['meta'] is Map<String, dynamic>
          ? PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : (json['meta'] is Map
              ? PaginationMeta.fromJson(
                  Map<String, dynamic>.from(json['meta'] as Map),
                )
              : null),
      success: success,
      error: errorMessage,
    );
  }
}
