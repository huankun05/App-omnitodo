import { IsOptional, IsString, IsBoolean } from 'class-validator';

export class UpdateFocusSessionDto {
  @IsOptional()
  @IsString()
  endTime?: string;

  @IsOptional()
  @IsBoolean()
  completed?: boolean;
}
