/// Note model - Domain entity
/// Represents a note in the application
class Note {
  final int? id;
  final String title;
  final String body;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Note({
    this.id,
    required this.title,
    required this.body,
    this.createdAt,
    this.updatedAt,
  });

  /// Create Note from JSON (from API response)
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['ID'] as int?,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: json['CreatedAt'] != null
          ? DateTime.parse(json['CreatedAt'] as String)
          : null,
      updatedAt: json['UpdatedAt'] != null
          ? DateTime.parse(json['UpdatedAt'] as String)
          : null,
    );
  }

  /// Convert Note to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'ID': id,
      'title': title,
      'body': body,
      if (createdAt != null) 'CreatedAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'UpdatedAt': updatedAt!.toIso8601String(),
    };
  }

  Note copyWith({
    int? id,
    String? title,
    String? body,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Note &&
        other.id == id &&
        other.title == title &&
        other.body == body;
  }

  @override
  int get hashCode {
    return Object.hash(id, title, body);
  }

  @override
  String toString() {
    return 'Note(id: $id, title: $title, body: $body)';
  }
}
