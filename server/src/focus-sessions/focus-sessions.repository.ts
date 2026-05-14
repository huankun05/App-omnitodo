import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateFocusSessionDto } from './dto/create-focus-session.dto';
import { UpdateFocusSessionDto } from './dto/update-focus-session.dto';

@Injectable()
export class FocusSessionsRepository {
  constructor(private prisma: PrismaService) {}

  findAll(userId: string) {
    return this.prisma.focusSession.findMany({
      where: { userId },
      orderBy: { startTime: 'desc' },
    });
  }

  async findStats(userId: string) {
    const sessions = await this.prisma.focusSession.findMany({
      where: { userId },
    });

    const totalSessions = sessions.length;
    const completedSessions = sessions.filter(s => s.completed).length;
    const totalMinutes = sessions.reduce((acc, s) => acc + s.duration, 0);
    const completionRate = totalSessions > 0 ? Math.round((completedSessions / totalSessions) * 100) : 0;

    return {
      totalSessions,
      totalMinutes,
      completionRate,
    };
  }

  create(createFocusSessionDto: CreateFocusSessionDto, userId: string) {
    return this.prisma.focusSession.create({
      data: {
        ...createFocusSessionDto,
        userId,
      },
    });
  }

  update(id: string, updateFocusSessionDto: UpdateFocusSessionDto, userId: string) {
    return this.prisma.focusSession.updateMany({
      where: { id, userId },
      data: updateFocusSessionDto,
    }).then(() => this.prisma.focusSession.findFirst({ where: { id, userId } }));
  }
}
