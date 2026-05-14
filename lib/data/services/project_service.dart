import 'package:dio/dio.dart';
import '../models/project_models.dart';

class ProjectService {
  final Dio _dio;

  ProjectService(this._dio);

  // ─── 项目 ─────────────────────────────────────────────────

  Future<List<Project>> getProjects() async {
    final response = await _dio.get('/projects');
    return (response.data as List)
        .map((item) => Project.fromJson(item))
        .toList();
  }

  Future<Project> createProject(ProjectCreate projectCreate) async {
    final response = await _dio.post('/projects', data: projectCreate.toJson());
    return Project.fromJson(response.data);
  }

  Future<Project> updateProject(String id, ProjectUpdate projectUpdate) async {
    final response = await _dio.patch('/projects/$id', data: projectUpdate.toJson());
    return Project.fromJson(response.data);
  }

  Future<void> deleteProject(String id) async {
    await _dio.delete('/projects/$id');
  }
}
