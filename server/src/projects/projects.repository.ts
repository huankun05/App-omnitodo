import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateProjectDto } from './dto/create-project.dto';
import { UpdateProjectDto } from './dto/update-project.dto';

@Injectable()
export class ProjectsRepository {
  constructor(private prisma: PrismaService) {}

  findAll(userId: string) {
    return this.prisma.project.findMany({
      where: { userId },
      include: { _count: { select: { tasks: true } } },
      orderBy: { order: 'asc' },
    });
  }

  findOne(id: string, userId: string) {
    return this.prisma.project.findFirst({
      where: { id, userId },
    });
  }

  create(dto: CreateProjectDto, userId: string) {
    return this.prisma.project.create({
      data: {
        name: dto.name,
        color: dto.color,
        icon: dto.icon,
        order: dto.order ?? 0,
        user: { connect: { id: userId } },
      },
    });
  }

  update(id: string, dto: UpdateProjectDto, userId: string) {
    return this.prisma.project.updateMany({
      where: { id, userId },
      data: dto,
    });
  }

  remove(id: string, userId: string) {
    return this.prisma.project.deleteMany({
      where: { id, userId },
    });
  }
}
