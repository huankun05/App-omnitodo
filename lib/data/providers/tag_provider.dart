import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final tagProviderProvider = ChangeNotifierProvider<TagProvider>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

class TagDefinition {
  final String name;
  final Color color;
  final bool isDefault;

  const TagDefinition({
    required this.name,
    required this.color,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'color': color.toARGB32(),
        'isDefault': isDefault,
      };

  factory TagDefinition.fromJson(Map<String, dynamic> json) => TagDefinition(
        name: json['name'] as String,
        color: Color(json['color'] as int),
        isDefault: json['isDefault'] as bool? ?? false,
      );
}

class TagProvider extends ChangeNotifier {
  static const _storageKey = 'omni_tags';
  static const _hiddenKey = 'omni_hidden_tags';

  List<TagDefinition> _allTags = [];
  Set<String> _hiddenNames = {};

  static const _defaultTags = [
    TagDefinition(name: 'Work', color: Color(0xFF2563EB), isDefault: true),
    TagDefinition(name: 'Personal', color: Color(0xFF9D4300), isDefault: true),
    TagDefinition(name: 'Health', color: Color(0xFF006874), isDefault: true),
    TagDefinition(name: 'Urgent', color: Color(0xFFBA1A1A), isDefault: true),
    TagDefinition(name: 'Study', color: Color(0xFF6750A4), isDefault: true),
    TagDefinition(name: 'Finance', color: Color(0xFF00696D), isDefault: true),
  ];

  List<TagDefinition> get allTags => List.unmodifiable(_allTags);
  Set<String> get hiddenNames => Set.unmodifiable(_hiddenNames);

  List<TagDefinition> get visibleTags =>
      _allTags.where((t) => !_hiddenNames.contains(t.name)).toList();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final tagsJson = prefs.getString(_storageKey);
    if (tagsJson != null && tagsJson.isNotEmpty) {
      final list = jsonDecode(tagsJson) as List;
      _allTags = list.map((e) => TagDefinition.fromJson(e)).toList();
    } else {
      _allTags = List.of(_defaultTags);
    }
    final hiddenJson = prefs.getString(_hiddenKey);
    if (hiddenJson != null && hiddenJson.isNotEmpty) {
      _hiddenNames = Set<String>.from(jsonDecode(hiddenJson));
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _storageKey, jsonEncode(_allTags.map((t) => t.toJson()).toList()));
    await prefs.setString(_hiddenKey, jsonEncode(_hiddenNames.toList()));
  }

  Future<void> addTag(String name, {Color? color}) async {
    if (_allTags.any((t) => t.name == name)) return;
    _allTags.add(TagDefinition(
      name: name,
      color: color ?? _colorForIndex(_allTags.length),
    ));
    notifyListeners();
    await _save();
  }

  Future<void> removeTag(String name) async {
    _allTags.removeWhere((t) => t.name == name);
    _hiddenNames.remove(name);
    notifyListeners();
    await _save();
  }

  Future<void> toggleVisibility(String name) async {
    if (_hiddenNames.contains(name)) {
      _hiddenNames.remove(name);
    } else {
      _hiddenNames.add(name);
    }
    notifyListeners();
    await _save();
  }

  Future<void> renameTag(String oldName, String newName) async {
    if (newName.isEmpty || newName == oldName) return;
    if (_allTags.any((t) => t.name == newName)) return;
    final idx = _allTags.indexWhere((t) => t.name == oldName);
    if (idx < 0) return;
    final old = _allTags[idx];
    _allTags[idx] = TagDefinition(name: newName, color: old.color, isDefault: old.isDefault);
    if (_hiddenNames.contains(oldName)) {
      _hiddenNames.remove(oldName);
      _hiddenNames.add(newName);
    }
    notifyListeners();
    await _save();
  }

  Future<void> updateTagColor(String name, Color color) async {
    final idx = _allTags.indexWhere((t) => t.name == name);
    if (idx < 0) return;
    final old = _allTags[idx];
    _allTags[idx] = TagDefinition(name: name, color: color, isDefault: old.isDefault);
    notifyListeners();
    await _save();
  }

  Color colorForTag(String name) {
    final tag = _allTags.cast<TagDefinition?>().firstWhere(
          (t) => t?.name == name,
          orElse: () => null,
        );
    return tag?.color ?? _colorForIndex(name.hashCode);
  }

  static const _palette = [
    Color(0xFF2563EB),
    Color(0xFF9D4300),
    Color(0xFF943700),
    Color(0xFF006874),
    Color(0xFF6750A4),
    Color(0xFF00696D),
    Color(0xFFBA1A1A),
    Color(0xFF386A20),
  ];

  Color _colorForIndex(int index) => _palette[index % _palette.length];
}
