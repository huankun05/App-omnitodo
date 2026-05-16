// 非 Web 平台（桌面/移动端）的数据库 Helper - 完整实现
import 'dart:async';
import 'dart:convert';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// 初始化 FFI
Future<void> initDatabase() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

class DatabaseHelper {
  static const _databaseName = "omnitodo.db";
  static const _databaseVersion = 4;

  static bool _initialized = false;
  static Future<void> ensureInitialized() async {
    if (!_initialized) {
      await initDatabase();
      _initialized = true;
    }
  }

  static const tableTasks = 'tasks';
  static const tableCategories = 'categories';
  static const tableFocusSessions = 'focus_sessions';
  static const tablePendingSync = 'pending_sync';

  static const columnTaskId = 'id';
  static const columnTaskTitle = 'title';
  static const columnTaskDescription = 'description';
  static const columnTaskIsCompleted = 'is_completed';
  static const columnTaskPriority = 'priority';
  static const columnTaskCategory = 'category';
  static const columnTaskDueDate = 'due_date';
  static const columnTaskIsStarred = 'is_starred';
  static const columnTaskCreatedAt = 'created_at';
  static const columnTaskUpdatedAt = 'updated_at';
  static const columnTaskDeletedAt = 'deleted_at';
  static const columnTaskOriginalCategory = 'original_category';
  static const columnTaskOriginalProjectId = 'original_project_id';

  static const columnCategoryId = 'id';
  static const columnCategoryName = 'name';
  static const columnCategoryColor = 'color';
  static const columnCategoryIcon = 'icon';

  static const columnFocusId = 'id';
  static const columnFocusTaskId = 'task_id';
  static const columnFocusStartTime = 'start_time';
  static const columnFocusEndTime = 'end_time';
  static const columnFocusDuration = 'duration';
  static const columnFocusCompleted = 'completed';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    await DatabaseHelper.ensureInitialized();
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = '$databasesPath/$_databaseName';
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createAllTables(db);
    await _insertDefaultData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tablePendingSync (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          op_type TEXT NOT NULL,
          target_id TEXT NOT NULL,
          payload TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 3) {
      // 添加 deleted_at 列用于回收站功能
      await db.execute('''
        ALTER TABLE $tableTasks ADD COLUMN $columnTaskDeletedAt TEXT
      ''');
    }
    if (oldVersion < 4) {
      // 添加 original_category 和 original_project_id 用于恢复任务
      await db.execute('''
        ALTER TABLE $tableTasks ADD COLUMN $columnTaskOriginalCategory TEXT
      ''');
      await db.execute('''
        ALTER TABLE $tableTasks ADD COLUMN $columnTaskOriginalProjectId TEXT
      ''');
    }
  }

  Future<void> _createAllTables(Database db) async {
    await db.execute('''
      CREATE TABLE $tableTasks (
        $columnTaskId TEXT PRIMARY KEY,
        $columnTaskTitle TEXT NOT NULL,
        $columnTaskDescription TEXT,
        $columnTaskIsCompleted INTEGER NOT NULL DEFAULT 0,
        $columnTaskPriority TEXT NOT NULL,
        $columnTaskCategory TEXT NOT NULL,
        $columnTaskDueDate TEXT,
        $columnTaskIsStarred INTEGER NOT NULL DEFAULT 0,
        $columnTaskCreatedAt TEXT NOT NULL,
        $columnTaskUpdatedAt TEXT,
        $columnTaskDeletedAt TEXT,
        $columnTaskOriginalCategory TEXT,
        $columnTaskOriginalProjectId TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableCategories (
        $columnCategoryId TEXT PRIMARY KEY,
        $columnCategoryName TEXT NOT NULL,
        $columnCategoryColor TEXT NOT NULL,
        $columnCategoryIcon TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableFocusSessions (
        $columnFocusId TEXT PRIMARY KEY,
        $columnFocusTaskId TEXT,
        $columnFocusStartTime TEXT NOT NULL,
        $columnFocusEndTime TEXT,
        $columnFocusDuration INTEGER NOT NULL,
        $columnFocusCompleted INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE $tablePendingSync (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        op_type TEXT NOT NULL,
        target_id TEXT NOT NULL,
        payload TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> _insertDefaultData(Database db) async {
    await db.insert(tableCategories, {
      columnCategoryId: 'work',
      columnCategoryName: 'Work',
      columnCategoryColor: '#004AC6',
      columnCategoryIcon: 'briefcase',
    });
    await db.insert(tableCategories, {
      columnCategoryId: 'personal',
      columnCategoryName: 'Personal',
      columnCategoryColor: '#4CAF50',
      columnCategoryIcon: 'person',
    });
    await db.insert(tableCategories, {
      columnCategoryId: 'health',
      columnCategoryName: 'Health',
      columnCategoryColor: '#FF5722',
      columnCategoryIcon: 'fitness_center',
    });

    final tasks = [
      {
        columnTaskId: '1',
        columnTaskTitle: 'Finalize Q4 Marketing Deck',
        columnTaskDescription: 'Complete all slides for the marketing presentation',
        columnTaskIsCompleted: 0,
        columnTaskPriority: 'high',
        columnTaskCategory: 'work',
        columnTaskDueDate: '2026-04-18T14:00:00Z',
        columnTaskIsStarred: 0,
        columnTaskCreatedAt: '2026-04-17T08:00:00Z',
        columnTaskUpdatedAt: '2026-04-17T08:00:00Z',
      },
      {
        columnTaskId: '2',
        columnTaskTitle: 'Morning standup meeting',
        columnTaskDescription: 'Daily team sync meeting',
        columnTaskIsCompleted: 1,
        columnTaskPriority: 'medium',
        columnTaskCategory: 'work',
        columnTaskDueDate: '2026-04-17T09:00:00Z',
        columnTaskIsStarred: 0,
        columnTaskCreatedAt: '2026-04-16T18:00:00Z',
        columnTaskUpdatedAt: '2026-04-17T09:15:00Z',
      },
      {
        columnTaskId: '3',
        columnTaskTitle: 'Buy fresh groceries for dinner',
        columnTaskDescription: 'Milk, eggs, vegetables, and fruit',
        columnTaskIsCompleted: 0,
        columnTaskPriority: 'medium',
        columnTaskCategory: 'personal',
        columnTaskDueDate: '2026-04-17T18:00:00Z',
        columnTaskIsStarred: 1,
        columnTaskCreatedAt: '2026-04-17T07:00:00Z',
        columnTaskUpdatedAt: '2026-04-17T07:00:00Z',
      },
      {
        columnTaskId: '4',
        columnTaskTitle: 'Gym Session: Leg Day',
        columnTaskDescription: 'Squats, lunges, deadlifts',
        columnTaskIsCompleted: 0,
        columnTaskPriority: 'low',
        columnTaskCategory: 'health',
        columnTaskDueDate: '2026-04-17T17:00:00Z',
        columnTaskIsStarred: 0,
        columnTaskCreatedAt: '2026-04-17T06:00:00Z',
        columnTaskUpdatedAt: '2026-04-17T06:00:00Z',
      },
      {
        columnTaskId: '5',
        columnTaskTitle: 'Submit Expense Report',
        columnTaskDescription: 'Q1 expense report',
        columnTaskIsCompleted: 0,
        columnTaskPriority: 'high',
        columnTaskCategory: 'work',
        columnTaskDueDate: '2026-04-15T17:00:00Z',
        columnTaskIsStarred: 0,
        columnTaskCreatedAt: '2026-04-10T10:00:00Z',
        columnTaskUpdatedAt: '2026-04-15T17:00:00Z',
      },
    ];
    for (final t in tasks) {
      await db.insert(tableTasks, t);
    }
  }

  // ─── 任务相关操作 ──────────────────────────────────────────

  Future<int> insertTask(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(tableTasks, row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAllTasks() async {
    final db = await database;
    return await db.query(tableTasks,
        orderBy: '$columnTaskCreatedAt DESC');
  }

  Future<List<Map<String, dynamic>>> queryTrashTasks() async {
    final db = await database;
    return await db.query(
      tableTasks,
      where: '$columnTaskDeletedAt IS NOT NULL',
      orderBy: '$columnTaskDeletedAt DESC',
    );
  }

  Future<Map<String, dynamic>?> queryTask(String id) async {
    final db = await database;
    final results = await db.query(
      tableTasks,
      where: '$columnTaskId = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateTask(Map<String, dynamic> row) async {
    final db = await database;
    final id = row[columnTaskId] as String;
    return await db.update(
      tableTasks,
      row,
      where: '$columnTaskId = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateTaskFields(String id, Map<String, dynamic> fields) async {
    final db = await database;
    return await db.update(
      tableTasks,
      fields,
      where: '$columnTaskId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(String id) async {
    final db = await database;
    return await db.delete(
      tableTasks,
      where: '$columnTaskId = ?',
      whereArgs: [id],
    );
  }

  // ─── 分类相关操作 ──────────────────────────────────────────

  Future<int> insertCategory(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(tableCategories, row,
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Map<String, dynamic>>> queryAllCategories() async {
    final db = await database;
    return await db.query(tableCategories);
  }

  Future<Map<String, dynamic>?> queryCategory(String id) async {
    final db = await database;
    final results = await db.query(
      tableCategories,
      where: '$columnCategoryId = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> deleteCategory(String id) async {
    final db = await database;
    return await db.delete(
      tableCategories,
      where: '$columnCategoryId = ?',
      whereArgs: [id],
    );
  }

  // ─── 专注会话相关操作 ──────────────────────────────────────

  Future<int> insertFocusSession(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(tableFocusSessions, row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAllFocusSessions() async {
    final db = await database;
    return await db.query(tableFocusSessions,
        orderBy: '$columnFocusStartTime DESC');
  }

  Future<int> updateFocusSession(Map<String, dynamic> row) async {
    final db = await database;
    final id = row[columnFocusId] as String;
    return await db.update(
      tableFocusSessions,
      row,
      where: '$columnFocusId = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>> getFocusStats() async {
    final db = await database;

    final totalSessionsResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $tableFocusSessions');
    final totalSessions = totalSessionsResult.first['count'] as int;

    final totalMinutesResult = await db.rawQuery(
        'SELECT SUM($columnFocusDuration) as total FROM $tableFocusSessions WHERE $columnFocusCompleted = 1');
    final totalMinutes = totalMinutesResult.first['total'] as int? ?? 0;

    final completedResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $tableFocusSessions WHERE $columnFocusCompleted = 1');
    final completedSessions = completedResult.first['count'] as int;
    final completionRate = totalSessions > 0
        ? (completedSessions * 100) ~/ totalSessions
        : 0;

    return {
      'totalSessions': totalSessions,
      'totalMinutes': totalMinutes,
      'completionRate': completionRate,
    };
  }

  Future<Map<String, dynamic>> getDailyFocusStats() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT
        COALESCE(SUM($columnFocusDuration), 0) as totalMinutes,
        COUNT(*) as totalSessions
      FROM $tableFocusSessions
      WHERE $columnFocusCompleted = 1
        AND date($columnFocusStartTime) = date('now', 'localtime')
    ''');
    return {
      'totalMinutes': result.first['totalMinutes'] as int,
      'totalSessions': result.first['totalSessions'] as int,
    };
  }

  Future<int> getTodayCompletedTaskCount() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) as count
      FROM $tableTasks
      WHERE $columnTaskIsCompleted = 1
        AND $columnTaskUpdatedAt IS NOT NULL
        AND date($columnTaskUpdatedAt) = date('now', 'localtime')
        AND $columnTaskDeletedAt IS NULL
    ''');
    return result.first['count'] as int;
  }

  // ─── 待同步队列 (Pending Sync) ─────────────────────────────

  Future<void> markPendingSync(
    String opType,
    String targetId,
    Map<String, dynamic> payload,
  ) async {
    final db = await database;
    await db.insert(tablePendingSync, {
      'op_type': opType,
      'target_id': targetId,
      'payload': jsonEncode(payload),
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getPendingSync() async {
    final db = await database;
    final rows = await db.query(tablePendingSync,
        orderBy: 'created_at ASC');
    return rows.map((r) {
      return {
        ...r,
        'payload': jsonDecode(r['payload'] as String) as Map<String, dynamic>,
      };
    }).toList();
  }

  Future<void> removePendingSync(int id) async {
    final db = await database;
    await db.delete(
      tablePendingSync,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getPendingSyncCount() async {
    final db = await database;
    final result = await db
        .rawQuery('SELECT COUNT(*) as count FROM $tablePendingSync');
    return result.first['count'] as int;
  }
}
