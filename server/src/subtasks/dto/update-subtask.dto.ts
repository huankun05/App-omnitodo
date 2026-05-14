import { IsOptional, IsString, IsBoolean, IsNumber } from 'class-validator';

export class UpdateSubTaskDto {
  @IsOptional()
  @IsString()
  title?: string;

  @IsOptional()
  @IsBoolean()
  completed?: boolean;

  @IsOptional()
  @IsNumber()
  order?: number;
}
