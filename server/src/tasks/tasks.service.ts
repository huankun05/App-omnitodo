import { Injectable } from '@nestjs/common';
import { TasksRepository } from './tasks.repository';
import { SubTasksRepository } from '../subtasks/subtasks.repository';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';

@Injectable()
export class TasksService {
  constructor(
    private tasksRepository: TasksRepository,
    private subTasksRepository: SubTasksRepository,
  ) {}

  findAll(userId: string, includeDeleted: boolean = false) {
    return this.tasksRepository.findAll(userId, includeDeleted);
  }

  findOne(id: string, userId: string) {
    return this.tasksRepository.findOneWithSubTasks(id, userId);
  }

  async create(createTaskDto: CreateTaskDto, userId: string) {
    const { subTasks, ...taskData } = createTaskDto;
    
    const task = await this.tasksRepository.create(taskData, userId);
    
    // 如果有子任务，同时创建
    if (subTasks && subTasks.length > 0) {
      await this.subTasksRepository.createMany(
        task.id,
        subTasks.map((st, index) => ({
          title: st.title,
          order: st.order ?? index,
        })),
      );
    }
    
    // 返回带子任务的任务
    return this.findOne(task.id, userId);
  }

  update(id: string, updateTaskDto: UpdateTaskDto, userId: string) {
    return this.tasksRepository.update(id, updateTaskDto, userId);
  }

  remove(id: string, userId: string) {
    return this.tasksRepository.remove(id, userId);
  }

  toggleStar(id: string, userId: string) {
    return this.tasksRepository.toggleStar(id, userId);
  }

  toggleCompletion(id: string, userId: string) {
    return this.tasksRepository.toggleCompletion(id, userId);
  }
}
