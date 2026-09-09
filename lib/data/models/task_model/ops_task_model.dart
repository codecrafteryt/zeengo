import '../api_response_model.dart';
import '../notification_model/notification_model.dart';

/// Ops task linked to a booking (`GET /client/home` → `tasks`, `/client/tasks`).
class OpsTask extends Serializable {
  String? id;
  String? title;
  String? description;
  String? priority;
  String? status;
  String? dueDate;
  String? completedAt;
  String? bookingId;
  String? znCode;
  String? createdAt;
  String? updatedAt;

  OpsTask({
    this.id,
    this.title,
    this.description,
    this.priority,
    this.status,
    this.dueDate,
    this.completedAt,
    this.bookingId,
    this.znCode,
    this.createdAt,
    this.updatedAt,
  });

  factory OpsTask.fromJson(Map<String, dynamic> json) => OpsTask(
        id: json['id']?.toString(),
        title: json['title']?.toString(),
        description: json['description']?.toString(),
        priority: json['priority']?.toString(),
        status: json['status']?.toString(),
        dueDate: json['dueDate']?.toString(),
        completedAt: json['completedAt']?.toString(),
        bookingId: json['bookingId']?.toString(),
        znCode: json['znCode']?.toString(),
        createdAt: json['createdAt']?.toString(),
        updatedAt: json['updatedAt']?.toString(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority,
        'status': status,
        'dueDate': dueDate,
        'completedAt': completedAt,
        'bookingId': bookingId,
        'znCode': znCode,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  bool get isUrgent => priority == 'urgent';
  bool get isDone => status == 'done';
  bool get isOpen => status == 'open' || !isDone;

  static List<OpsTask> listFrom(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => OpsTask.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

/// `GET /client/tasks` → envelope `data`.
class OpsTaskListResult {
  final String? znCode;
  final String? bookingId;
  final List<OpsTask> items;
  final PaginationMeta? meta;
  final bool success;
  final String error;

  OpsTaskListResult({
    this.znCode,
    this.bookingId,
    required this.items,
    this.meta,
    this.success = true,
    this.error = '',
  });

  factory OpsTaskListResult.fromEnvelope(Map<String, dynamic> json) {
    final success = json['success'] == true;
    final raw = json['data'];
    String error = '';
    final err = json['error'];
    if (err is Map) {
      error = err['message']?.toString() ?? err['code']?.toString() ?? '';
    } else if (err is String) {
      error = err;
    }

    if (raw is! Map) {
      return OpsTaskListResult(
        items: const [],
        success: success,
        error: error,
      );
    }

    final map = Map<String, dynamic>.from(raw);
    final metaRaw = map['meta'];
    return OpsTaskListResult(
      znCode: map['znCode']?.toString(),
      bookingId: map['bookingId']?.toString(),
      items: OpsTask.listFrom(map['data']),
      meta: metaRaw is Map
          ? PaginationMeta.fromJson(Map<String, dynamic>.from(metaRaw))
          : null,
      success: success,
      error: error,
    );
  }
}
