import { PrismaService } from '../prisma/prisma.service';
import { CreateSubTaskDto } from './dto/create-subtask.dto';
import { UpdateSubTaskDto } from './dto/update-subtask.dto';
export declare class SubTasksRepository {
    private prisma;
    constructor(prisma: PrismaService);
    findAllByTaskId(taskId: string, userId: string): import(".prisma/client").Prisma.PrismaPromise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        order: number;
        completed: boolean;
        taskId: string;
    }[]>;
    findOne(id: string, taskId: string, userId: string): import(".prisma/client").Prisma.Prisma__SubTaskClient<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        order: number;
        completed: boolean;
        taskId: string;
    }, null, import("@prisma/client/runtime/library").DefaultArgs>;
    create(createSubTaskDto: CreateSubTaskDto, taskId: string, userId: string): import(".prisma/client").Prisma.Prisma__SubTaskClient<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        order: number;
        completed: boolean;
        taskId: string;
    }, never, import("@prisma/client/runtime/library").DefaultArgs>;
    update(id: string, updateSubTaskDto: UpdateSubTaskDto, taskId: string, userId: string): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        order: number;
        completed: boolean;
        taskId: string;
    }>;
    remove(id: string, taskId: string, userId: string): import(".prisma/client").Prisma.PrismaPromise<import(".prisma/client").Prisma.BatchPayload>;
    toggleCompletion(id: string, taskId: string, userId: string): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        order: number;
        completed: boolean;
        taskId: string;
    }>;
    createMany(taskId: string, subtasks: {
        title: string;
        order?: number;
    }[]): import(".prisma/client").Prisma.PrismaPromise<import(".prisma/client").Prisma.BatchPayload>;
}
