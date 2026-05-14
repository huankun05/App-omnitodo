"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.TasksRepository = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let TasksRepository = class TasksRepository {
    constructor(prisma) {
        this.prisma = prisma;
    }
    findAll(userId, includeDeleted = false) {
        return this.prisma.task.findMany({
            where: {
                userId,
                deletedAt: includeDeleted ? { not: null } : null,
            },
            include: {
                subTasks: {
                    orderBy: { order: 'asc' },
                },
                project: true,
            },
            orderBy: { createdAt: 'desc' },
        });
    }
    findOne(id, userId) {
        return this.prisma.task.findFirst({
            where: { id, userId },
            include: { project: true },
        });
    }
    findOneWithSubTasks(id, userId) {
        return this.prisma.task.findFirst({
            where: { id, userId },
            include: {
                subTasks: {
                    orderBy: { order: 'asc' },
                },
                project: true,
            },
        });
    }
    create(createTaskDto, userId) {
        const data = {
            ...createTaskDto,
            userId,
        };
        if (data.dueDate) {
            try {
                const date = new Date(data.dueDate);
                if (!isNaN(date.getTime())) {
                    data.dueDate = date.toISOString();
                }
            }
            catch {
                data.dueDate = null;
            }
        }
        return this.prisma.task.create({ data });
    }
    async update(id, updateTaskDto, userId) {
        const existingTask = await this.findOne(id, userId);
        if (!existingTask) {
            throw new Error(`Task not found or access denied: ${id}`);
        }
        const nullableFields = ['projectId', 'deletedAt', 'originalCategory', 'originalProjectId'];
        const data = {};
        for (const [key, value] of Object.entries(updateTaskDto)) {
            if (value !== undefined) {
                if (value === null) {
                    if (nullableFields.includes(key)) {
                        data[key] = value;
                    }
                }
                else {
                    data[key] = value;
                }
            }
        }
        if (Object.keys(data).length === 0) {
            return existingTask;
        }
        if (data.dueDate) {
            try {
                const date = new Date(data.dueDate);
                if (!isNaN(date.getTime())) {
                    data.dueDate = date.toISOString();
                }
            }
            catch {
                data.dueDate = null;
            }
        }
        if ('deletedAt' in data) {
            if (data.deletedAt === null) {
                data.deletedAt = null;
                if (!('originalCategory' in data)) {
                    delete data.originalCategory;
                }
                if (!('originalProjectId' in data)) {
                    delete data.originalProjectId;
                }
            }
            else {
                try {
                    const date = new Date(data.deletedAt);
                    if (!isNaN(date.getTime())) {
                        data.deletedAt = date.toISOString();
                    }
                }
                catch {
                    data.deletedAt = new Date().toISOString();
                }
                delete data.originalCategory;
                delete data.originalProjectId;
            }
        }
        if ('projectId' in data && data.projectId !== null) {
            const project = await this.prisma.project.findFirst({
                where: { id: data.projectId, userId },
            });
            if (!project) {
                throw new Error(`Project not found or access denied: ${data.projectId}`);
            }
        }
        const result = await this.prisma.task.updateMany({
            where: { id, userId },
            data,
        });
        if (result.count === 0) {
            throw new Error(`Failed to update task: ${id}`);
        }
        const updatedTask = await this.findOne(id, userId);
        if (!updatedTask) {
            throw new Error(`Task not found after update: ${id}`);
        }
        return updatedTask;
    }
    remove(id, userId) {
        return this.prisma.task.deleteMany({
            where: { id, userId },
        });
    }
    toggleStar(id, userId) {
        return this.prisma.task.findFirst({ where: { id, userId } })
            .then(task => {
            if (!task)
                return null;
            return this.prisma.task.update({
                where: { id },
                data: { isStarred: !task.isStarred },
            });
        });
    }
    toggleCompletion(id, userId) {
        return this.prisma.task.findFirst({ where: { id, userId } })
            .then(task => {
            if (!task)
                return null;
            return this.prisma.task.update({
                where: { id },
                data: { isCompleted: !task.isCompleted },
            });
        });
    }
};
exports.TasksRepository = TasksRepository;
exports.TasksRepository = TasksRepository = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], TasksRepository);
//# sourceMappingURL=tasks.repository.js.map