import { PrismaService } from '../prisma/prisma.service';
import { CreateFocusSessionDto } from './dto/create-focus-session.dto';
import { UpdateFocusSessionDto } from './dto/update-focus-session.dto';
export declare class FocusSessionsRepository {
    private prisma;
    constructor(prisma: PrismaService);
    findAll(userId: string): import(".prisma/client").Prisma.PrismaPromise<{
        id: string;
        userId: string;
        completed: boolean;
        taskId: string | null;
        duration: number;
        endTime: Date | null;
        startTime: Date;
    }[]>;
    findStats(userId: string): Promise<{
        totalSessions: number;
        totalMinutes: number;
        completionRate: number;
    }>;
    create(createFocusSessionDto: CreateFocusSessionDto, userId: string): import(".prisma/client").Prisma.Prisma__FocusSessionClient<{
        id: string;
        userId: string;
        completed: boolean;
        taskId: string | null;
        duration: number;
        endTime: Date | null;
        startTime: Date;
    }, never, import("@prisma/client/runtime/library").DefaultArgs>;
    update(id: string, updateFocusSessionDto: UpdateFocusSessionDto, userId: string): Promise<{
        id: string;
        userId: string;
        completed: boolean;
        taskId: string | null;
        duration: number;
        endTime: Date | null;
        startTime: Date;
    }>;
}
