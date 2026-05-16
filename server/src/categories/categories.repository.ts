import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateCategoryDto } from './dto/create-category.dto';

@Injectable()
export class CategoriesRepository {
  constructor(private prisma: PrismaService) {}

  findAll(userId: string) {
    return this.prisma.category.findMany({
      where: { userId },
    });
  }

  async create(createCategoryDto: CreateCategoryDto, userId: string) {
    const existing = await this.prisma.category.findFirst({
      where: { name: createCategoryDto.name, userId },
    });
    if (existing) return existing;
    return this.prisma.category.create({
      data: {
        ...createCategoryDto,
        userId,
      },
    });
  }

  remove(id: string, userId: string) {
    return this.prisma.category.deleteMany({
      where: { id, userId },
    });
  }
}
