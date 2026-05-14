import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { TasksModule } from './tasks/tasks.module';
import { CategoriesModule } from './categories/categories.module';
import { FocusSessionsModule } from './focus-sessions/focus-sessions.module';
import { PrismaModule } from './prisma/prisma.module';
import { UsersModule } from './users/users.module';
import { TelemetryModule } from './telemetry/telemetry.module';
import { SubTasksModule } from './subtasks/subtasks.module';
import { ProjectsModule } from './projects/projects.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    PrismaModule,
    UsersModule,
    AuthModule,
    TasksModule,
    CategoriesModule,
    FocusSessionsModule,
    TelemetryModule,
    SubTasksModule,
    ProjectsModule,
  ],
})
export class AppModule {}
