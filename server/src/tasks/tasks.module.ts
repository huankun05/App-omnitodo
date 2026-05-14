import { Module } from '@nestjs/common';
import { TasksService } from './tasks.service';
import { TasksController } from './tasks.controller';
import { TasksRepository } from './tasks.repository';
import { SubTasksModule } from '../subtasks/subtasks.module';

@Module({
  imports: [SubTasksModule],
  providers: [TasksService, TasksRepository],
  controllers: [TasksController],
  exports: [TasksService],
})
export class TasksModule {}
