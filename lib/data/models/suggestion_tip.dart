import 'package:flutter/material.dart';

/// Tip card model — maps `/client/suggestions` note items.
class SuggestionTip {
  const SuggestionTip({
    required this.id,
    required this.title,
    required this.description,
    this.actionLabel = '',
    this.icon = Icons.lightbulb_outline_rounded,
    this.actionIcon = Icons.arrow_outward_rounded,
    this.iconColor,
    this.actionValue,
    this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String actionLabel;
  final IconData icon;
  final IconData actionIcon;
  final Color? iconColor;
  final String? actionValue;
  final String? createdAt;

  factory SuggestionTip.fromJson(Map<String, dynamic> json) {
    final body = json['body']?.toString() ?? '';
    final description =
        json['description']?.toString().trim().isNotEmpty == true
            ? json['description'].toString()
            : body;
    final title = json['title']?.toString().trim().isNotEmpty == true
        ? json['title'].toString()
        : (json['authorName']?.toString().trim().isNotEmpty == true
            ? json['authorName'].toString()
            : 'Suggestion');

    return SuggestionTip(
      id: json['id']?.toString() ?? '',
      title: title,
      description: description,
      actionLabel: json['action_label']?.toString() ??
          json['actionLabel']?.toString() ??
          '',
      actionValue: json['action_value']?.toString() ??
          json['actionValue']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'action_label': actionLabel,
        'action_value': actionValue,
        'createdAt': createdAt,
      };

  static List<SuggestionTip> listFrom(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => SuggestionTip.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
