import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/task_models.dart';
import '../services/task_service.dart';
import 'task_provider.dart';

final tagProviderProvider = ChangeNotifierProvider<TagProvider>((ref) {
  final service = ref.watch(taskServiceProvider.future);
  final tagProvider = TagProvider._(ref);
  // 异步加载：等 TaskService 就绪后加载 Category
  service.then((s) async {
    tagProvider._taskService = s;
    await tagProvider.load();
  });
  return tagProvider;
});

/// TagProvider — 基于数据库 Category 的标签管理
class TagProvider extends ChangeNotifier {
  static const _hiddenKey = 'omni_hidden_tags';
  static const _uuid = Uuid();
  static const builtinToday = 'Today';
  static const builtinTodayColor = '#FF6750A4';
  final Ref _ref;

  TaskService? _taskService;
  List<Category> _allCategories = [];
  Set<String> _hiddenNames = {};
  bool _loaded = false;

  TagProvider._(this._ref);

  List<Category> get allCategories => List.unmodifiable(_allCategories);
  Set<String> get hiddenNames => Set.unmodifiable(_hiddenNames);
  bool get isLoaded => _loaded;

  List<Category> get visibleCategories =>
      _allCategories.where((t) => !_hiddenNames.contains(t.name)).toList();

  List<String> get allTagNames => _allCategories.map((c) => c.name).toList();
  List<String> get visibleTagNames =>
      visibleCategories.map((c) => c.name).toList();

  Future<void> load() async {
    if (_taskService == null) return;
    final raw = await _taskService!.getCategories();
    // 按 name 去重：保留第一个出现的
    final seen = <String>{};
    _allCategories = [];
    for (final c in raw) {
      if (seen.add(c.name.toLowerCase())) {
        _allCategories.add(c);
      }
    }
    // 确保内置 Today 标签始终存在
    if (!_allCategories.any((c) => c.name == builtinToday)) {
      _allCategories.insert(0, const Category(
        id: '__builtin_today__',
        name: builtinToday,
        color: builtinTodayColor,
      ));
    }
    final prefs = await SharedPreferences.getInstance();
    final hiddenJson = prefs.getString(_hiddenKey);
    if (hiddenJson != null && hiddenJson.isNotEmpty) {
      _hiddenNames = Set<String>.from(jsonDecode(hiddenJson));
    }
    // Today 不允许隐藏
    _hiddenNames.remove(builtinToday);
    _loaded = true;
    notifyListeners();
  }

  Future<void> _saveHidden() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_hiddenKey, jsonEncode(_hiddenNames.toList()));
  }

  Future<void> addTag(String name, {Color? color}) async {
    if (_taskService == null) return;
    if (name == builtinToday) return;
    if (_allCategories.any((c) => c.name.toLowerCase() == name.toLowerCase())) return;
    final colorStr = color != null
        ? '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}'
        : _hexForIndex(_allCategories.length);
    final category = Category(id: _uuid.v4(), name: name, color: colorStr);
    await _taskService!.createCategory(category);
    _allCategories.add(category);
    notifyListeners();
  }

  Future<void> removeTag(String name) async {
    if (_taskService == null) return;
    if (name == builtinToday) return;
    final cat = _allCategories.cast<Category?>().firstWhere(
          (c) => c?.name == name, orElse: () => null);
    if (cat == null) return;
    await _taskService!.deleteCategory(cat.id);
    _allCategories.removeWhere((c) => c.name == name);
    _hiddenNames.remove(name);
    notifyListeners();
    await _saveHidden();
  }

  Future<void> renameTag(String oldName, String newName) async {
    if (_taskService == null) return;
    if (oldName == builtinToday) return;
    if (newName.isEmpty || newName == oldName) return;
    if (_allCategories.any((c) => c.name.toLowerCase() == newName.toLowerCase())) return;
    final idx = _allCategories.indexWhere((c) => c.name == oldName);
    if (idx < 0) return;
    final old = _allCategories[idx];
    await _taskService!.deleteCategory(old.id);
    final updated = Category(id: _uuid.v4(), name: newName, color: old.color, icon: old.icon);
    await _taskService!.createCategory(updated);
    _allCategories = [..._allCategories]..[idx] = updated;
    if (_hiddenNames.contains(oldName)) {
      _hiddenNames = {..._hiddenNames}..remove(oldName)..add(newName);
    }
    notifyListeners();
    await _saveHidden();
    _cleanupOrphans();
  }

  Future<void> updateTagColor(String name, Color color) async {
    if (_taskService == null) return;
    final idx = _allCategories.indexWhere((c) => c.name == name);
    if (idx < 0) return;
    final old = _allCategories[idx];
    final colorStr = '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
    final updated = old.copyWith(color: colorStr);
    await _taskService!.updateCategory(updated);
    _allCategories = [..._allCategories]..[idx] = updated;
    notifyListeners();
    _cleanupOrphans();
  }

  Future<void> toggleVisibility(String name) async {
    if (_hiddenNames.contains(name)) {
      _hiddenNames.remove(name);
    } else {
      _hiddenNames.add(name);
    }
    notifyListeners();
    await _saveHidden();
  }

  Color colorForTag(String name) {
    final cat = _allCategories.cast<Category?>().firstWhere(
          (c) => c?.name == name, orElse: () => null);
    if (cat != null) return parseHexColor(cat.color);
    return _colorForIndex(name.hashCode);
  }

  Future<void> syncTagsFromTasks(List<Task> tasks) async {
    final existingNames = _allCategories.map((c) => c.name).toSet();
    for (final task in tasks) {
      if (task.category.isEmpty) continue;
      for (final tag in task.category.split('|')) {
        final name = tag.trim();
        if (name.isNotEmpty && !existingNames.contains(name)) {
          await addTag(name);
          existingNames.add(name);
        }
      }
    }
  }

  static Color parseHexColor(String hex) {
    try {
      hex = hex.replaceFirst('#', '');
      if (hex.length == 6) hex = 'FF$hex';
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return const Color(0xFF2563EB);
    }
  }

  static const _palette = [
    '#2563EB', '#9D4300', '#943700', '#006874',
    '#6750A4', '#00696D', '#BA1A1A', '#386A20',
  ];

  String _hexForIndex(int index) => _palette[index % _palette.length];
  Color _colorForIndex(int index) => parseHexColor(_hexForIndex(index));

  /// 删除本地数据库中不在当前列表里的旧 Category 记录（rename/colorUpdate 后清理旧 UUID）
  void _cleanupOrphans() {
    if (_taskService == null) return;
    final activeIds = _allCategories.map((c) => c.id).toSet();
    _taskService!.deleteOrphanCategories(activeIds);
  }
}
