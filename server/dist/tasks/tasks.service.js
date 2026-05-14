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
exports.TasksService = void 0;
const common_1 = require("@nestjs/common");
const tasks_repository_1 = require("./tasks.repository");
const subtasks_repository_1 = require("../subtasks/subtasks.repository");
let TasksService = class TasksService {
    constructor(tasksRepository, subTasksRepository) {
        this.tasksRepository = tasksRepository;
        this.subTasksRepository = subTasksRepository;
    }
    findAll(userId, includeDeleted = false) {
        return this.tasksRepository.findAll(userId, includeDeleted);
    }
    findOne(id, userId) {
        return this.tasksRepository.findOneWithSubTasks(id, userId);
    }
    async create(createTaskDto, userId) {
        const { subTasks, ...taskData } = createTaskDto;
        const task = await this.tasksRepository.create(taskData, userId);
        if (subTasks && subTasks.length > 0) {
            await this.subTasksRepository.createMany(task.id, subTasks.map((st, index) => ({
                title: st.title,
                order: st.order ?? index,
            })));
        }
        return this.findOne(task.id, userId);
    }
    update(id, updateTaskDto, userId) {
        return this.tasksRepository.update(id, updateTaskDto, userId);
    }
    remove(id, userId) {
        return this.tasksRepository.remove(id, userId);
    }
    toggleStar(id, userId) {
        return this.tasksRepository.toggleStar(id, userId);
    }
    toggleCompletion(id, userId) {
        return this.tasksRepository.toggleCompletion(id, userId);
    }
};
exports.TasksService = TasksService;
exports.TasksService = TasksService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [tasks_repository_1.TasksRepository,
        subtasks_repository_1.SubTasksRepository])
], TasksService);
//# sourceMappingURL=tasks.service.js.map