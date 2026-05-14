import { IsNotEmpty, IsOptional, IsString, IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateSubTaskDto {
  @IsNotEmpty()
  @IsString()
  title: string;

  @IsOptional()
  order?: number;
}

export class CreateTaskDto {
  @IsNotEmpty()
  @IsString()
  title: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsString()
  priority?: string;

  @IsNotEmpty()
  @IsString()
  category: string;

  @IsOptional()
  dueDate?: string;

  @IsOptional()
  @IsString()
  projectId?: string;

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateSubTaskDto)
  subTasks?: CreateSubTaskDto[];
}
