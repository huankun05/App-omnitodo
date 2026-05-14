import { Controller, Post, Body, UseGuards } from '@nestjs/common';
import { TelemetryService } from './telemetry.service';
import { BatchTelemetryDto } from './dto/batch-telemetry.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@Controller('telemetry')
@UseGuards(JwtAuthGuard)
export class TelemetryController {
  constructor(private readonly telemetryService: TelemetryService) {}

  @Post('batch')
  saveBatch(@Body() dto: BatchTelemetryDto, @CurrentUser() user: any) {
    return this.telemetryService.saveBatch(dto, user.userId);
  }
}
