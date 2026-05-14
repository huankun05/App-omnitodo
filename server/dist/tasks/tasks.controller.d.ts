import { TasksService } from './tasks.service';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
export declare class TasksController {
    private readonly tasksService;
    constructor(tasksService: TasksService);
    findAll(user: any, deleted?: string): import(".prisma/client").Prisma.PrismaPromise<({
        project: {
            id: string;
            name: string;
            createdAt: Date;
            updatedAt: Date;
            order: number;
            userId: string;
            color: string;
            icon: string | null;
        };
        subTasks: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            title: string;
            order: number;
            completed: boolean;
            taskId: string;
        }[];
    } & {
        category: string;
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        description: string | null;
        priority: string;
        dueDate: Date | null;
        projectId: string | null;
        isCompleted: boolean;
        isStarred: boolean;
        deletedAt: Date | null;
        originalCategory: string | null;
        originalProjectId: string | null;
        userId: string;
    })[]>;
    findOne(id: string, user: any): import(".prisma/client").Prisma.Prisma__TaskClient<{
        project: {
            id: string;
            name: string;
            createdAt: Date;
            updatedAt: Date;
            order: number;
            userId: string;
            color: string;
            icon: string | null;
        };
        subTasks: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            title: string;
            order: number;
            completed: boolean;
            taskId: string;
        }[];
    } & {
        category: string;
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        description: string | null;
        priority: string;
        dueDate: Date | null;
        projectId: string | null;
        isCompleted: boolean;
        isStarred: boolean;
        deletedAt: Date | null;
        originalCategory: string | null;
        originalProjectId: string | null;
        userId: string;
    }, null, import("@prisma/client/runtime/library").DefaultArgs>;
    create(createTaskDto: CreateTaskDto, user: any): Promise<{
        project: {
            id: string;
            name: string;
            createdAt: Date;
            updatedAt: Date;
            order: number;
            userId: string;
            color: string;
            icon: string | null;
        };
        subTasks: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            title: string;
            order: number;
            completed: boolean;
            taskId: string;
        }[];
    } & {
        category: string;
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        description: string | null;
        priority: string;
        dueDate: Date | null;
        projectId: string | null;
        isCompleted: boolean;
        isStarred: boolean;
        deletedAt: Date | null;
        originalCategory: string | null;
        originalProjectId: string | null;
        userId: string;
    }>;
    update(id: string, updateTaskDto: UpdateTaskDto, user: any): Promise<{
        project: {
            id: string;
            name: string;
            createdAt: Date;
            updatedAt: Date;
            order: number;
            userId: string;
            color: string;
            icon: string | null;
        };
    } & {
        category: string;
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        description: string | null;
        priority: string;
        dueDate: Date | null;
        projectId: string | null;
        isCompleted: boolean;
        isStarred: boolean;
        deletedAt: Date | null;
        originalCategory: string | null;
        originalProjectId: string | null;
        userId: string;
    }>;
    remove(id: string, user: any): import(".prisma/client").Prisma.PrismaPromise<import(".prisma/client").Prisma.BatchPayload>;
    toggleStar(id: string, user: any): Promise<{
        category: string;
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        description: string | null;
        priority: string;
        dueDate: Date | null;
        projectId: string | null;
        isCompleted: boolean;
        isStarred: boolean;
        deletedAt: Date | null;
        originalCategory: string | null;
        originalProjectId: string | null;
        userId: string;
    }>;
    toggleCompletion(id: string, user: any): Promise<{
        category: string;
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        description: string | null;
        priority: string;
        dueDate: Date | null;
        projectId: string | null;
        isCompleted: boolean;
        isStarred: boolean;
        deletedAt: Date | null;
        originalCategory: string | null;
        originalProjectId: string | null;
        userId: string;
    }>;
}
