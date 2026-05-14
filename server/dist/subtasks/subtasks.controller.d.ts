import { SubTasksService } from './subtasks.service';
import { CreateSubTaskDto } from './dto/create-subtask.dto';
import { UpdateSubTaskDto } from './dto/update-subtask.dto';
export declare class SubTasksController {
    private subTasksService;
    constructor(subTasksService: SubTasksService);
    findAll(taskId: string, user: {
        userId: string;
    }): import(".prisma/client").Prisma.PrismaPromise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        order: number;
        completed: boolean;
        taskId: string;
    }[]>;
    findOne(taskId: string, id: string, user: {
        userId: string;
    }): import(".prisma/client").Prisma.Prisma__SubTaskClient<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        order: number;
        completed: boolean;
        taskId: string;
    }, null, import("@prisma/client/runtime/library").DefaultArgs>;
    create(taskId: string, createSubTaskDto: CreateSubTaskDto, user: {
        userId: string;
    }): import(".prisma/client").Prisma.Prisma__SubTaskClient<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        order: number;
        completed: boolean;
        taskId: string;
    }, never, import("@prisma/client/runtime/library").DefaultArgs>;
    update(taskId: string, id: string, updateSubTaskDto: UpdateSubTaskDto, user: {
        userId: string;
    }): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        order: number;
        completed: boolean;
        taskId: string;
    }>;
    remove(taskId: string, id: string, user: {
        userId: string;
    }): import(".prisma/client").Prisma.PrismaPromise<import(".prisma/client").Prisma.BatchPayload>;
    toggleCompletion(taskId: string, id: string, user: {
        userId: string;
    }): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        order: number;
        completed: boolean;
        taskId: string;
    }>;
}
