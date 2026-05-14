import { Injectable } from '@nestjs/common';
import { FocusSessionsRepository } from './focus-sessions.repository';
import { CreateFocusSessionDto } from './dto/create-focus-session.dto';
import { UpdateFocusSessionDto } from './dto/update-focus-session.dto';

@Injectable()
export class FocusSessionsService {
  constructor(private focusSessionsRepository: FocusSessionsRepository) {}

  findAll(userId: string) {
    return this.focusSessionsRepository.findAll(userId);
  }

  findStats(userId: string) {
    return this.focusSessionsRepository.findStats(userId);
  }

  create(createFocusSessionDto: CreateFocusSessionDto, userId: string) {
    return this.focusSessionsRepository.create(createFocusSessionDto, userId);
  }

  update(id: string, updateFocusSessionDto: UpdateFocusSessionDto, userId: string) {
    return this.focusSessionsRepository.update(id, updateFocusSessionDto, userId);
  }
}
