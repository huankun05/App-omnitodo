export declare class CreateSubTaskDto {
    title: string;
    order?: number;
}
export declare class CreateTaskDto {
    title: string;
    description?: string;
    priority?: string;
    category: string;
    dueDate?: string;
    projectId?: string;
    subTasks?: CreateSubTaskDto[];
}
