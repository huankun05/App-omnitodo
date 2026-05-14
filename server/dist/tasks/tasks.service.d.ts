import { TasksRepository } from './tasks.repository';
import { SubTasksRepository } from '../subtasks/subtasks.repository';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
export declare class TasksService {
    private tasksRepository;
    private subTasksRepository;
    constructor(tasksRepository: TasksRepository, subTasksRepository: SubTasksRepository);
    findAll(userId: string, includeDeleted?: boolean): import(".prisma/client").Prisma.PrismaPromise<({
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
    findOne(id: string, userId: string): import(".prisma/client").Prisma.Prisma__TaskClient<{
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
    create(createTaskDto: CreateTaskDto, userId: string): Promise<{
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
    update(id: string, updateTaskDto: UpdateTaskDto, userId: string): Promise<{
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
    remove(id: string, userId: string): import(".prisma/client").Prisma.PrismaPromise<import(".prisma/client").Prisma.BatchPayload>;
    toggleStar(id: string, userId: string): Promise<{
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
    toggleCompletion(id: string, userId: string): Promise<{
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
