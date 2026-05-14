import { Injectable } from '@nestjs/common';
import { SubTasksRepository } from './subtasks.repository';
import { CreateSubTaskDto } from './dto/create-subtask.dto';
import { UpdateSubTaskDto } from './dto/update-subtask.dto';

@Injectable()
export class SubTasksService {
  constructor(private subTasksRepository: SubTasksRepository) {}

  findAllByTaskId(taskId: string, userId: string) {
    return this.subTasksRepository.findAllByTaskId(taskId, userId);
  }

  findOne(id: string, taskId: string, userId: string) {
    return this.subTasksRepository.findOne(id, taskId, userId);
  }

  create(createSubTaskDto: CreateSubTaskDto, taskId: string, userId: string) {
    return this.subTasksRepository.create(createSubTaskDto, taskId, userId);
  }

  update(id: string, updateSubTaskDto: UpdateSubTaskDto, taskId: string, userId: string) {
    return this.subTasksRepository.update(id, updateSubTaskDto, taskId, userId);
  }

  remove(id: string, taskId: string, userId: string) {
    return this.subTasksRepository.remove(id, taskId, userId);
  }

  toggleCompletion(id: string, taskId: string, userId: string) {
    return this.subTasksRepository.toggleCompletion(id, taskId, userId);
  }

  createMany(taskId: string, subtasks: { title: string; order?: number }[], userId: string) {
    return this.subTasksRepository.createMany(taskId, subtasks);
  }
}
