import { Injectable, NotFoundException } from '@nestjs/common';
import { ProjectsRepository } from './projects.repository';
import { CreateProjectDto } from './dto/create-project.dto';
import { UpdateProjectDto } from './dto/update-project.dto';

@Injectable()
export class ProjectsService {
  constructor(private projectsRepository: ProjectsRepository) {}

  findAll(userId: string) {
    return this.projectsRepository.findAll(userId);
  }

  async findOne(id: string, userId: string) {
    const project = await this.projectsRepository.findOne(id, userId);
    if (!project) throw new NotFoundException('Project not found');
    return project;
  }

  create(dto: CreateProjectDto, userId: string) {
    return this.projectsRepository.create(dto, userId);
  }

  update(id: string, dto: UpdateProjectDto, userId: string) {
    return this.projectsRepository.update(id, dto, userId);
  }

  remove(id: string, userId: string) {
    return this.projectsRepository.remove(id, userId);
  }
}
