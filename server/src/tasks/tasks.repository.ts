import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';

@Injectable()
export class TasksRepository {
  constructor(private prisma: PrismaService) {}

  findAll(userId: string, includeDeleted: boolean = false) {
    return this.prisma.task.findMany({
      where: { 
        userId,
        // 如果 includeDeleted=true，只返回已删除的任务（deletedAt 不为 null）
        // 如果 includeDeleted=false，只返回未删除的任务（deletedAt 为 null）
        deletedAt: includeDeleted ? { not: null } : null,
      },
      include: {
        subTasks: {
          orderBy: { order: 'asc' },
        },
        project: true,
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  findOne(id: string, userId: string) {
    return this.prisma.task.findFirst({
      where: { id, userId },
      include: { project: true },
    });
  }

  findOneWithSubTasks(id: string, userId: string) {
    return this.prisma.task.findFirst({
      where: { id, userId },
      include: {
        subTasks: {
          orderBy: { order: 'asc' },
        },
        project: true,
      },
    });
  }

  create(createTaskDto: CreateTaskDto, userId: string) {
    // 处理 dueDate 格式：确保是有效的 ISO-8601 格式
    const data: any = {
      ...createTaskDto,
      userId,
    };
    
    // 如果有 dueDate，确保格式正确
    if (data.dueDate) {
      try {
        // 尝试解析并转换为 ISO-8601 格式
        const date = new Date(data.dueDate);
        if (!isNaN(date.getTime())) {
          data.dueDate = date.toISOString();
        }
      } catch {
        // 如果解析失败，设置为 null
        data.dueDate = null;
      }
    }
    
    return this.prisma.task.create({ data });
  }

  async update(id: string, updateTaskDto: UpdateTaskDto, userId: string) {
    // 先验证任务是否存在且有权限
    const existingTask = await this.findOne(id, userId);
    if (!existingTask) {
      throw new Error(`Task not found or access denied: ${id}`);
    }
    
    // 定义允许设置为 null 的字段（这些字段可以明确设置为 null）
    const nullableFields = ['projectId', 'deletedAt', 'originalCategory', 'originalProjectId'];
    
    // 只保留实际提供的字段（过滤掉 undefined 和 null，除了允许为 null 的字段）
    const data: any = {};
    for (const [key, value] of Object.entries(updateTaskDto)) {
      if (value !== undefined) {
        // 如果值是 null，只有在允许为 null 的字段列表中才保留
        if (value === null) {
          if (nullableFields.includes(key)) {
            data[key] = value;
          }
        } else {
          // 值不为 null，直接保留
          data[key] = value;
        }
      }
    }
    
    // 如果没有任何字段需要更新，直接返回现有任务
    if (Object.keys(data).length === 0) {
      return existingTask;
    }
    
    // 处理 dueDate 格式
    if (data.dueDate) {
      try {
        const date = new Date(data.dueDate);
        if (!isNaN(date.getTime())) {
          data.dueDate = date.toISOString();
        }
      } catch {
        data.dueDate = null;
      }
    }
    
    // 处理 deletedAt 格式
    if ('deletedAt' in data) {
      if (data.deletedAt === null) {
        // 恢复：从回收站恢复，deletedAt 设为 null
        data.deletedAt = null;
        // 清理 originalCategory 和 originalProjectId（如果未提供）
        if (!('originalCategory' in data)) {
          delete data.originalCategory;
        }
        if (!('originalProjectId' in data)) {
          delete data.originalProjectId;
        }
      } else {
        // 软删除：设置为当前时间
        try {
          const date = new Date(data.deletedAt);
          if (!isNaN(date.getTime())) {
            data.deletedAt = date.toISOString();
          }
        } catch {
          data.deletedAt = new Date().toISOString();
        }
        // 删除时清除 originalCategory 和 originalProjectId
        delete data.originalCategory;
        delete data.originalProjectId;
      }
    }
    
    // 如果更新 projectId，验证项目是否存在且属于当前用户
    if ('projectId' in data && data.projectId !== null) {
      const project = await this.prisma.project.findFirst({
        where: { id: data.projectId, userId },
      });
      if (!project) {
        throw new Error(`Project not found or access denied: ${data.projectId}`);
      }
    }
    
    // 执行更新
    const result = await this.prisma.task.updateMany({
      where: { id, userId },
      data,
    });
    
    if (result.count === 0) {
      throw new Error(`Failed to update task: ${id}`);
    }
    
    // 返回更新后的任务
    const updatedTask = await this.findOne(id, userId);
    if (!updatedTask) {
      throw new Error(`Task not found after update: ${id}`);
    }
    
    return updatedTask;
  }

  remove(id: string, userId: string) {
    return this.prisma.task.deleteMany({
      where: { id, userId },
    });
  }

  toggleStar(id: string, userId: string) {
    return this.prisma.task.findFirst({ where: { id, userId } })
      .then(task => {
        if (!task) return null;
        return this.prisma.task.update({
          where: { id },
          data: { isStarred: !task.isStarred },
        });
      });
  }

  toggleCompletion(id: string, userId: string) {
    return this.prisma.task.findFirst({ where: { id, userId } })
      .then(task => {
        if (!task) return null;
        return this.prisma.task.update({
          where: { id },
          data: { isCompleted: !task.isCompleted },
        });
      });
  }
}
