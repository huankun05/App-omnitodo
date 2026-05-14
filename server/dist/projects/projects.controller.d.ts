import { ProjectsService } from './projects.service';
import { CreateProjectDto } from './dto/create-project.dto';
import { UpdateProjectDto } from './dto/update-project.dto';
export declare class ProjectsController {
    private readonly projectsService;
    constructor(projectsService: ProjectsService);
    findAll(user: any): import(".prisma/client").Prisma.PrismaPromise<({
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
    create(dto: CreateProjectDto, user: any): import(".prisma/client").Prisma.Prisma__ProjectClient<{
        id: string;
        name: string;
        createdAt: Date;
        updatedAt: Date;
        order: number;
        userId: string;
        color: string;
        icon: string | null;
    }, never, import("@prisma/client/runtime/library").DefaultArgs>;
    update(id: string, dto: UpdateProjectDto, user: any): import(".prisma/client").Prisma.PrismaPromise<import(".prisma/client").Prisma.BatchPayload>;
    remove(id: string, user: any): import(".prisma/client").Prisma.PrismaPromise<import(".prisma/client").Prisma.BatchPayload>;
}
