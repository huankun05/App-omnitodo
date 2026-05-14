import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateSubTaskDto } from './dto/create-subtask.dto';
import { UpdateSubTaskDto } from './dto/update-subtask.dto';

@Injectable()
export class SubTasksRepository {
  constructor(private prisma: PrismaService) {}

  findAllByTaskId(taskId: string, userId: string) {
    return this.prisma.subTask.findMany({
      where: { taskId },
      orderBy: { order: 'asc' },
    });
  }

  findOne(id: string, taskId: string, userId: string) {
    return this.prisma.subTask.findFirst({
      where: { id, taskId },
    });
  }

  create(createSubTaskDto: CreateSubTaskDto, taskId: string, userId: string) {
    return this.prisma.subTask.create({
      data: {
        ...createSubTaskDto,
        taskId,
      },
    });
  }

  update(id: string, updateSubTaskDto: UpdateSubTaskDto, taskId: string, userId: string) {
    const data: any = {};
    
    if (updateSubTaskDto.title !== undefined && updateSubTaskDto.title !== null && updateSubTaskDto.title !== '') {
      data.title = updateSubTaskDto.title;
    }
    
    if (updateSubTaskDto.completed !== undefined && updateSubTaskDto.completed !== null && typeof updateSubTaskDto.completed === 'boolean') {
      data.completed = updateSubTaskDto.completed;
    }
    
    if (updateSubTaskDto.order !== undefined && updateSubTaskDto.order !== null && typeof updateSubTaskDto.order === 'number') {
      data.order = updateSubTaskDto.order;
    }
    
    if (Object.keys(data).length === 0) {
      return this.findOne(id, taskId, userId);
    }
    
    return this.prisma.subTask.updateMany({
      where: { id, taskId },
      data,
    }).then(() => this.findOne(id, taskId, userId));
  }

  remove(id: string, taskId: string, userId: string) {
    return this.prisma.subTask.deleteMany({
      where: { id, taskId },
    });
  }

  toggleCompletion(id: string, taskId: string, userId: string) {
    return this.prisma.subTask.findFirst({ where: { id, taskId } })
      .then(subTask => {
        if (!subTask) return null;
        return this.prisma.subTask.update({
          where: { id },
          data: { completed: !subTask.completed },
        });
      });
  }

  // 批量创建子任务
  createMany(taskId: string, subtasks: { title: string; order?: number }[]) {
    return this.prisma.subTask.createMany({
      data: subtasks.map((st, index) => ({
        title: st.title,
        order: st.order ?? index,
        taskId,
      })),
    });
  }
}
