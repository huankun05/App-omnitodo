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
exports.SubTasksRepository = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let SubTasksRepository = class SubTasksRepository {
    constructor(prisma) {
        this.prisma = prisma;
    }
    findAllByTaskId(taskId, userId) {
        return this.prisma.subTask.findMany({
            where: { taskId },
            orderBy: { order: 'asc' },
        });
    }
    findOne(id, taskId, userId) {
        return this.prisma.subTask.findFirst({
            where: { id, taskId },
        });
    }
    create(createSubTaskDto, taskId, userId) {
        return this.prisma.subTask.create({
            data: {
                ...createSubTaskDto,
                taskId,
            },
        });
    }
    update(id, updateSubTaskDto, taskId, userId) {
        const data = {};
        if (updateSubTaskDto.title !== undefined && updateSubTaskDto.title !== null && updateSubTaskDto.title !== '') {
            data.title = updateSubTaskDto.title;
        }
        if (updateSubTaskDto.completed !== undefined && updateSubTaskDto.completed !== null && typeof updateSubTaskDto.completed === 'boolean') {
            data.completed = updateSubTaskDto.completed;
        }
        if (updateSubTaskDto.order !== undefined && updateSubTaskDto.order !== null && typeof updateSubTaskDto.order === 'number') {
            data.order = updateSubTaskDto.order;
        }
        if (Object.keys(data).length === 0) {
            return this.findOne(id, taskId, userId);
        }
        return this.prisma.subTask.updateMany({
            where: { id, taskId },
            data,
        }).then(() => this.findOne(id, taskId, userId));
    }
    remove(id, taskId, userId) {
        return this.prisma.subTask.deleteMany({
            where: { id, taskId },
        });
    }
    toggleCompletion(id, taskId, userId) {
        return this.prisma.subTask.findFirst({ where: { id, taskId } })
            .then(subTask => {
            if (!subTask)
                return null;
            return this.prisma.subTask.update({
                where: { id },
                data: { completed: !subTask.completed },
            });
        });
    }
    createMany(taskId, subtasks) {
        return this.prisma.subTask.createMany({
            data: subtasks.map((st, index) => ({
                title: st.title,
                order: st.order ?? index,
                taskId,
            })),
        });
    }
};
exports.SubTasksRepository = SubTasksRepository;
exports.SubTasksRepository = SubTasksRepository = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], SubTasksRepository);
//# sourceMappingURL=subtasks.repository.js.map