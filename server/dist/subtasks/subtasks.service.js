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
exports.SubTasksService = void 0;
const common_1 = require("@nestjs/common");
const subtasks_repository_1 = require("./subtasks.repository");
let SubTasksService = class SubTasksService {
    constructor(subTasksRepository) {
        this.subTasksRepository = subTasksRepository;
    }
    findAllByTaskId(taskId, userId) {
        return this.subTasksRepository.findAllByTaskId(taskId, userId);
    }
    findOne(id, taskId, userId) {
        return this.subTasksRepository.findOne(id, taskId, userId);
    }
    create(createSubTaskDto, taskId, userId) {
        return this.subTasksRepository.create(createSubTaskDto, taskId, userId);
    }
    update(id, updateSubTaskDto, taskId, userId) {
        return this.subTasksRepository.update(id, updateSubTaskDto, taskId, userId);
    }
    remove(id, taskId, userId) {
        return this.subTasksRepository.remove(id, taskId, userId);
    }
    toggleCompletion(id, taskId, userId) {
        return this.subTasksRepository.toggleCompletion(id, taskId, userId);
    }
    createMany(taskId, subtasks, userId) {
        return this.subTasksRepository.createMany(taskId, subtasks);
    }
};
exports.SubTasksService = SubTasksService;
exports.SubTasksService = SubTasksService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [subtasks_repository_1.SubTasksRepository])
], SubTasksService);
//# sourceMappingURL=subtasks.service.js.map