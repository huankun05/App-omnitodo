import { Controller, Get, Post, Patch, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { SubTasksService } from './subtasks.service';
import { CreateSubTaskDto } from './dto/create-subtask.dto';
import { UpdateSubTaskDto } from './dto/update-subtask.dto';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';

@Controller('tasks/:taskId/subtasks')
@UseGuards(JwtAuthGuard)
export class SubTasksController {
  constructor(private subTasksService: SubTasksService) {}

  @Get()
  findAll(
    @Param('taskId') taskId: string,
    @CurrentUser() user: { userId: string },
  ) {
    return this.subTasksService.findAllByTaskId(taskId, user.userId);
  }

  @Get(':id')
  findOne(
    @Param('taskId') taskId: string,
    @Param('id') id: string,
    @CurrentUser() user: { userId: string },
  ) {
    return this.subTasksService.findOne(id, taskId, user.userId);
  }

  @Post()
  create(
    @Param('taskId') taskId: string,
    @Body() createSubTaskDto: CreateSubTaskDto,
    @CurrentUser() user: { userId: string },
  ) {
    return this.subTasksService.create(createSubTaskDto, taskId, user.userId);
  }

  @Patch(':id')
  update(
    @Param('taskId') taskId: string,
    @Param('id') id: string,
    @Body() updateSubTaskDto: UpdateSubTaskDto,
    @CurrentUser() user: { userId: string },
  ) {
    return this.subTasksService.update(id, updateSubTaskDto, taskId, user.userId);
  }

  @Delete(':id')
  remove(
    @Param('taskId') taskId: string,
    @Param('id') id: string,
    @CurrentUser() user: { userId: string },
  ) {
    return this.subTasksService.remove(id, taskId, user.userId);
  }

  @Post(':id/toggle')
  toggleCompletion(
    @Param('taskId') taskId: string,
    @Param('id') id: string,
    @CurrentUser() user: { userId: string },
  ) {
    return this.subTasksService.toggleCompletion(id, taskId, user.userId);
  }
}
