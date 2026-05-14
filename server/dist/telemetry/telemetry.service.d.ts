import { PrismaService } from '../prisma/prisma.service';
import { BatchTelemetryDto } from './dto/batch-telemetry.dto';
export declare class TelemetryService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    saveBatch(dto: BatchTelemetryDto, userId: string): Promise<{
        saved: number;
    }>;
}
