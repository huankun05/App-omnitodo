import { Controller, Get, Post, Patch, Body, Param, UseGuards } from '@nestjs/common';
import { FocusSessionsService } from './focus-sessions.service';
import { CreateFocusSessionDto } from './dto/create-focus-session.dto';
import { UpdateFocusSessionDto } from './dto/update-focus-session.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@Controller('focus-sessions')
@UseGuards(JwtAuthGuard)
export class FocusSessionsController {
  constructor(private readonly focusSessionsService: FocusSessionsService) {}

  @Get()
  findAll(@CurrentUser() user: any) {
    return this.focusSessionsService.findAll(user.userId);
  }

  @Get('stats')
  findStats(@CurrentUser() user: any) {
    return this.focusSessionsService.findStats(user.userId);
  }

  @Post()
  create(@Body() createFocusSessionDto: CreateFocusSessionDto, @CurrentUser() user: any) {
    return this.focusSessionsService.create(createFocusSessionDto, user.userId);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateFocusSessionDto: UpdateFocusSessionDto, @CurrentUser() user: any) {
    return this.focusSessionsService.update(id, updateFocusSessionDto, user.userId);
  }
}
