import { ProjectsRepository } from './projects.repository';
import { CreateProjectDto } from './dto/create-project.dto';
import { UpdateProjectDto } from './dto/update-project.dto';
export declare class ProjectsService {
    private projectsRepository;
    constructor(projectsRepository: ProjectsRepository);
    findAll(userId: string): import(".prisma/client").Prisma.PrismaPromise<({
        _count: {
            tasks: number;
        };
    } & {
        id: string;
        name: string;
        createdAt: Date;
        updatedAt: Date;
        order: number;
        userId: string;
        color: string;
        icon: string | null;
    })[]>;
    findOne(id: string, userId: string): Promise<{
        id: string;
        name: string;
        createdAt: Date;
        updatedAt: Date;
        order: number;
        userId: string;
        color: string;
        icon: string | null;
    }>;
    create(dto: CreateProjectDto, userId: string): import(".prisma/client").Prisma.Prisma__ProjectClient<{
        id: string;
        name: string;
        createdAt: Date;
        updatedAt: Date;
        order: number;
        userId: string;
        color: string;
        icon: string | null;
    }, never, import("@prisma/client/runtime/library").DefaultArgs>;
    update(id: string, dto: UpdateProjectDto, userId: string): import(".prisma/client").Prisma.PrismaPromise<import(".prisma/client").Prisma.BatchPayload>;
    remove(id: string, userId: string): import(".prisma/client").Prisma.PrismaPromise<import(".prisma/client").Prisma.BatchPayload>;
}
