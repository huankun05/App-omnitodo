// Web 平台数据库 Helper - 空实现
// Web 平台暂不支持本地数据库，所有操作返回空结果
// 仅用于保持代码兼容性

class DatabaseHelper {
  // Web 平台不需要初始化
  static Future<void> ensureInitialized() async {
    // 空操作
  }

  // 空实现
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

  // 所有操作返回空结果
  Future<dynamic> get database async => null;

  Future<int> insertTask(Map<String, dynamic> row) async => 0;
  Future<List<Map<String, dynamic>>> queryAllTasks() async => [];
  Future<List<Map<String, dynamic>>> queryTrashTasks() async => [];
  Future<Map<String, dynamic>?> queryTask(String id) async => null;
  Future<int> updateTask(Map<String, dynamic> row) async => 0;
  Future<int> updateTaskFields(String id, Map<String, dynamic> fields) async => 0;
  Future<int> deleteTask(String id) async => 0;

  Future<int> insertCategory(Map<String, dynamic> row) async => 0;
  Future<List<Map<String, dynamic>>> queryAllCategories() async => [];
  Future<Map<String, dynamic>?> queryCategory(String id) async => null;
  Future<int> updateCategory(Map<String, dynamic> row) async => 0;
  Future<int> deleteCategory(String id) async => 0;

  Future<int> insertFocusSession(Map<String, dynamic> row) async => 0;
  Future<List<Map<String, dynamic>>> queryAllFocusSessions() async => [];
  Future<int> updateFocusSession(Map<String, dynamic> row) async => 0;
  Future<Map<String, dynamic>> getFocusStats() async => {
    'totalSessions': 0,
    'totalMinutes': 0,
    'completionRate': 0,
  };

  Future<Map<String, dynamic>> getDailyFocusStats() async => {
    'totalMinutes': 0,
    'totalSessions': 0,
  };

  Future<int> getTodayCompletedTaskCount() async => 0;

  Future<void> markPendingSync(String opType, String targetId, Map<String, dynamic> payload) async {}
  Future<List<Map<String, dynamic>>> getPendingSync() async => [];
  Future<void> removePendingSync(int id) async {}
  Future<int> getPendingSyncCount() async => 0;
}
