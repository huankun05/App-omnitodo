import { Injectable } from '@nestjs/common';
import { CategoriesRepository } from './categories.repository';
import { CreateCategoryDto } from './dto/create-category.dto';

@Injectable()
export class CategoriesService {
  constructor(private categoriesRepository: CategoriesRepository) {}

  findAll(userId: string) {
    return this.categoriesRepository.findAll(userId);
  }

  create(createCategoryDto: CreateCategoryDto, userId: string) {
    return this.categoriesRepository.create(createCategoryDto, userId);
  }

  remove(id: string, userId: string) {
    return this.categoriesRepository.remove(id, userId);
  }
}
