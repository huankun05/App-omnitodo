import { Module } from '@nestjs/common';
import { FocusSessionsService } from './focus-sessions.service';
import { FocusSessionsController } from './focus-sessions.controller';
import { FocusSessionsRepository } from './focus-sessions.repository';

@Module({
  providers: [FocusSessionsService, FocusSessionsRepository],
  controllers: [FocusSessionsController],
  exports: [FocusSessionsService],
})
export class FocusSessionsModule {}
