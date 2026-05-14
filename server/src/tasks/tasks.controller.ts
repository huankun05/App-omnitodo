import { Controller, Get, Post, Patch, Delete, Body, Param, Query, UseGuards } from '@nestjs/common';
import { TasksService } from './tasks.service';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@Controller('tasks')
@UseGuards(JwtAuthGuard)
export class TasksController {
  constructor(private readonly tasksService: TasksService) {}

  @Get()
  findAll(@CurrentUser() user: any, @Query('deleted') deleted?: string) {
    const includeDeleted = deleted === 'true';
    return this.tasksService.findAll(user.userId, includeDeleted);
  }

  @Get(':id')
  findOne(@Param('id') id: string, @CurrentUser() user: any) {
    return this.tasksService.findOne(id, user.userId);
  }

  @Post()
  create(@Body() createTaskDto: CreateTaskDto, @CurrentUser() user: any) {
    return this.tasksService.create(createTaskDto, user.userId);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateTaskDto: UpdateTaskDto, @CurrentUser() user: any) {
    return this.tasksService.update(id, updateTaskDto, user.userId);
  }

  @Delete(':id')
  remove(@Param('id') id: string, @CurrentUser() user: any) {
    return this.tasksService.remove(id, user.userId);
  }

  @Patch(':id/toggle-star')
  toggleStar(@Param('id') id: string, @CurrentUser() user: any) {
    return this.tasksService.toggleStar(id, user.userId);
  }

  @Patch(':id/toggle-completion')
  toggleCompletion(@Param('id') id: string, @CurrentUser() user: any) {
    return this.tasksService.toggleCompletion(id, user.userId);
  }
}
