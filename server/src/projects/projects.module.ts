import { Module } from '@nestjs/common';
import { PassportModule } from '@nestjs/passport';
import { ProjectsService } from './projects.service';
import { ProjectsController } from './projects.controller';
import { ProjectsRepository } from './projects.repository';

@Module({
  imports: [
    PassportModule.register({ defaultStrategy: 'jwt' }),
  ],
  providers: [ProjectsService, ProjectsRepository],
  controllers: [ProjectsController],
  exports: [ProjectsService],
})
export class ProjectsModule {}
