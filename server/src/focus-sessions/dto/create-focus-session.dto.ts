import { IsOptional, IsString, IsInt } from 'class-validator';

export class CreateFocusSessionDto {
  @IsOptional()
  @IsString()
  taskId?: string;

  @IsInt()
  duration: number;
}
