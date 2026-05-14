export declare class TelemetryEventDto {
    event_type: string;
    payload: Record<string, any>;
    created_at: string;
}
export declare class BatchTelemetryDto {
    events: TelemetryEventDto[];
}
