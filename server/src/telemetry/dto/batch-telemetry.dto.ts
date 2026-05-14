import { IsArray, IsNotEmpty } from 'class-validator';
import { Type } from 'class-transformer';

export class TelemetryEventDto {
  event_type: string;
  payload: Record<string, any>;
  created_at: string;
}

export class BatchTelemetryDto {
  @IsArray()
  @IsNotEmpty()
  @Type(() => TelemetryEventDto)
  events: TelemetryEventDto[];
}
