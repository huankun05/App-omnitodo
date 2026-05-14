import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/project_service.dart';
import '../models/project_models.dart';
import '../../core/network/network_manager.dart';

final projectServiceProvider = FutureProvider<ProjectService>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return ProjectService(dio);
});

final projectNotifierProvider =
    AsyncNotifierProvider<ProjectNotifier, List<Project>>(() {
  return ProjectNotifier();
});

class ProjectNotifier extends AsyncNotifier<List<Project>> {
  @override
  Future<List<Project>> build() async {
    final service = await ref.watch(projectServiceProvider.future);
    return service.getProjects();
  }

  Future<void> refreshProjects() async {
    state = const AsyncValue.loading();
    final service = await ref.watch(projectServiceProvider.future);
    state = await AsyncValue.guard(() => service.getProjects());
  }

  Future<void> addProject(ProjectCreate projectCreate) async {
    final service = await ref.watch(projectServiceProvider.future);
    final newProject = await service.createProject(projectCreate);

    state.whenData((projects) {
      state = AsyncValue.data([...projects, newProject]);
    });
  }

  Future<void> updateProject(String id, ProjectUpdate projectUpdate) async {
    final service = await ref.watch(projectServiceProvider.future);
    final updatedProject = await service.updateProject(id, projectUpdate);

    state.whenData((projects) {
      final updated = projects.map((p) {
        return p.id == id ? updatedProject : p;
      }).toList();
      state = AsyncValue.data(updated);
    });
  }

  Future<void> deleteProject(String id) async {
    final service = await ref.watch(projectServiceProvider.future);
    await service.deleteProject(id);

    state.whenData((projects) {
      state = AsyncValue.data(projects.where((p) => p.id != id).toList());
    });
  }
}
