import { PrismaService } from '../prisma/prisma.service';
import { CreateProjectDto } from './dto/create-project.dto';
import { UpdateProjectDto } from './dto/update-project.dto';
export declare class ProjectsRepository {
    private prisma;
    constructor(prisma: PrismaService);
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
    findOne(id: string, userId: string): import(".prisma/client").Prisma.Prisma__ProjectClient<{
        id: string;
        name: string;
        createdAt: Date;
        updatedAt: Date;
        order: number;
        userId: string;
        color: string;
        icon: string | null;
    }, null, import("@prisma/client/runtime/library").DefaultArgs>;
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
