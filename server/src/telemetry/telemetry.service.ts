import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { BatchTelemetryDto } from './dto/batch-telemetry.dto';

@Injectable()
export class TelemetryService {
  constructor(private readonly prisma: PrismaService) {}

  async saveBatch(dto: BatchTelemetryDto, userId: string): Promise<{ saved: number }> {
    const records = dto.events.map((e) => ({
      userId,
      eventType: e.event_type,
      payload: JSON.stringify(e.payload ?? {}),
      clientCreatedAt: e.created_at ? new Date(e.created_at) : new Date(),
    }));

    await this.prisma.telemetryEvent.createMany({ data: records });
    return { saved: records.length };
  }
}
