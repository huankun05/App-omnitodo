import { FocusSessionsService } from './focus-sessions.service';
import { CreateFocusSessionDto } from './dto/create-focus-session.dto';
import { UpdateFocusSessionDto } from './dto/update-focus-session.dto';
export declare class FocusSessionsController {
    private readonly focusSessionsService;
    constructor(focusSessionsService: FocusSessionsService);
    findAll(user: any): import(".prisma/client").Prisma.PrismaPromise<{
        id: string;
        userId: string;
        completed: boolean;
        taskId: string | null;
        duration: number;
        endTime: Date | null;
        startTime: Date;
    }[]>;
    findStats(user: any): Promise<{
        totalSessions: number;
        totalMinutes: number;
        completionRate: number;
    }>;
    create(createFocusSessionDto: CreateFocusSessionDto, user: any): import(".prisma/client").Prisma.Prisma__FocusSessionClient<{
        id: string;
        userId: string;
        completed: boolean;
        taskId: string | null;
        duration: number;
        endTime: Date | null;
        startTime: Date;
    }, never, import("@prisma/client/runtime/library").DefaultArgs>;
    update(id: string, updateFocusSessionDto: UpdateFocusSessionDto, user: any): Promise<{
        id: string;
        userId: string;
        completed: boolean;
        taskId: string | null;
        duration: number;
        endTime: Date | null;
        startTime: Date;
    }>;
}
