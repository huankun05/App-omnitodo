import { SubTasksRepository } from './subtasks.repository';
import { CreateSubTaskDto } from './dto/create-subtask.dto';
import { UpdateSubTaskDto } from './dto/update-subtask.dto';
export declare class SubTasksService {
    private subTasksRepository;
    constructor(subTasksRepository: SubTasksRepository);
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
    }[], userId: string): import(".prisma/client").Prisma.PrismaPromise<import(".prisma/client").Prisma.BatchPayload>;
}
