import { IsOptional, IsString, IsBoolean } from 'class-validator';

export class UpdateTaskDto {
  @IsOptional()
  @IsString()
  title?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsBoolean()
  isCompleted?: boolean;

  @IsOptional()
  @IsString()
  priority?: string;

  @IsOptional()
  @IsString()
  category?: string;

  @IsOptional()
  dueDate?: string;

  @IsOptional()
  @IsBoolean()
  isStarred?: boolean;

  @IsOptional()
  deletedAt?: string | null; // 软删除/恢复时间

  @IsOptional()
  @IsString()
  originalCategory?: string | null; // 删除时保存，恢复时使用

  @IsOptional()
  @IsString()
  originalProjectId?: string | null; // 删除时保存，恢复时使用

  @IsOptional()
  @IsString()
  projectId?: string | null; // null = 移出项目
}
