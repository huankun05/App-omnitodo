import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_bootstrap.dart';
import '../../data/providers/task_provider.dart';
import '../../data/providers/project_provider.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // 执行应用初始化
      await ref.read(appBootstrapProvider.future);

      // 检查登录状态
      final isLoggedIn = await ref.read(isLoggedInProvider.future);

      if (isLoggedIn) {
        // 预加载 HomeScreen 所需的数据，等待实际数据加载完成
        // 使用 future 确保数据真正从网络/数据库加载完毕
        await Future.wait([
          ref.read(taskNotifierProvider.future),
          ref.read(projectNotifierProvider.future),
        ]);
      }

      // 导航到相应页面
      if (mounted) {
        if (isLoggedIn) {
          context.go('/tasks');
        } else {
          context.go('/login');
        }
      }
    } catch (e) {
      // 初始化失败，默认导航到登录页
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              '应用初始化中...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
