import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class Subject {
  final String id;
  final String title;
  final IconData? icon;
  final List<Unit> units;

  const Subject({
    required this.id,
    required this.title,
    this.icon,
    required this.units,
  });

  Subject copyWith({List<Unit>? units}) {
    return Subject(
      id: id,
      title: title,
      icon: icon,
      units: units ?? this.units,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Subject &&
        other.id == id &&
        other.title == title &&
        other.icon == icon &&
        _listEquals(other.units, units);
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ icon.hashCode ^ units.hashCode;

  bool _listEquals(List<Unit> a, List<Unit> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class Unit {
  final String id;
  final String title;
  final List<Lesson> lessons;
  final bool isActivated;

  const Unit({
    required this.id,
    required this.title,
    required this.lessons,
    this.isActivated = false,
  });

  Unit copyWith({
    String? id,
    String? title,
    List<Lesson>? lessons,
    bool? isActivated,
  }) {
    return Unit(
      id: id ?? this.id,
      title: title ?? this.title,
      lessons: lessons ?? this.lessons,
      isActivated: isActivated ?? this.isActivated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Unit &&
        other.id == id &&
        other.title == title &&
        other.isActivated == isActivated &&
        _listEquals(other.lessons, lessons);
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ isActivated.hashCode ^ lessons.hashCode;

  bool _listEquals(List<Lesson> a, List<Lesson> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class Lesson {
  final String id;
  final String title;
  final List<Section> sections;
  final bool isActivated;

  const Lesson({
    required this.id,
    required this.title,
    required this.sections,
    this.isActivated = false,
  });

  Lesson copyWith({
    String? id,
    String? title,
    List<Section>? sections,
    bool? isActivated,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      sections: sections ?? this.sections,
      isActivated: isActivated ?? this.isActivated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Lesson &&
        other.id == id &&
        other.title == title &&
        other.isActivated == isActivated &&
        _listEquals(other.sections, sections);
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ isActivated.hashCode ^ sections.hashCode;

  bool _listEquals(List<Section> a, List<Section> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class Section {
  final String id;
  final String title;
  final bool isCompleted;
  final bool isActivated;
  final String videoId;

  const Section({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.isActivated = false,
    required this.videoId,
  });

  Section copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    bool? isActivated,
    String? videoId,
  }) {
    return Section(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      isActivated: isActivated ?? this.isActivated,
      videoId: videoId ?? this.videoId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Section &&
        other.id == id &&
        other.title == title &&
        other.isCompleted == isCompleted &&
        other.isActivated == isActivated &&
        other.videoId == videoId;
  }

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ isCompleted.hashCode ^ isActivated.hashCode ^ videoId.hashCode;
}