import { TelemetryService } from './telemetry.service';
import { BatchTelemetryDto } from './dto/batch-telemetry.dto';
export declare class TelemetryController {
    private readonly telemetryService;
    constructor(telemetryService: TelemetryService);
    saveBatch(dto: BatchTelemetryDto, user: any): Promise<{
        saved: number;
    }>;
}
