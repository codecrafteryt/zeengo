import 'package:flutter/material.dart';

/// API-ready tip model. Fields map cleanly to a future JSON payload.
class SuggestionTip {
  const SuggestionTip({
    required this.id,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.icon,
    required this.actionIcon,
    this.iconColor,
    this.actionValue,
  });

  final String id;
  final String title;
  final String description;
  final String actionLabel;
  final IconData icon;
  final IconData actionIcon;
  final Color? iconColor;

  /// Optional deep-link / payload for future API actions.
  final String? actionValue;

  factory SuggestionTip.fromJson(Map<String, dynamic> json) {
    return SuggestionTip(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      actionLabel: json['action_label']?.toString() ?? '',
      icon: Icons.lightbulb_outline_rounded,
      actionIcon: Icons.arrow_outward_rounded,
      actionValue: json['action_value']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'action_label': actionLabel,
        'action_value': actionValue,
      };
}
