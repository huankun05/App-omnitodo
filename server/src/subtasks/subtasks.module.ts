import { Module } from '@nestjs/common';
import { SubTasksService } from './subtasks.service';
import { SubTasksController } from './subtasks.controller';
import { SubTasksRepository } from './subtasks.repository';

@Module({
  providers: [SubTasksService, SubTasksRepository],
  controllers: [SubTasksController],
  exports: [SubTasksService, SubTasksRepository],
})
export class SubTasksModule {}
