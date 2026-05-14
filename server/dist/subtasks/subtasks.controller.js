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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SubTasksController = void 0;
const common_1 = require("@nestjs/common");
const subtasks_service_1 = require("./subtasks.service");
const create_subtask_dto_1 = require("./dto/create-subtask.dto");
const update_subtask_dto_1 = require("./dto/update-subtask.dto");
const current_user_decorator_1 = require("../common/decorators/current-user.decorator");
const jwt_auth_guard_1 = require("../common/guards/jwt-auth.guard");
let SubTasksController = class SubTasksController {
    constructor(subTasksService) {
        this.subTasksService = subTasksService;
    }
    findAll(taskId, user) {
        return this.subTasksService.findAllByTaskId(taskId, user.userId);
    }
    findOne(taskId, id, user) {
        return this.subTasksService.findOne(id, taskId, user.userId);
    }
    create(taskId, createSubTaskDto, user) {
        return this.subTasksService.create(createSubTaskDto, taskId, user.userId);
    }
    update(taskId, id, updateSubTaskDto, user) {
        return this.subTasksService.update(id, updateSubTaskDto, taskId, user.userId);
    }
    remove(taskId, id, user) {
        return this.subTasksService.remove(id, taskId, user.userId);
    }
    toggleCompletion(taskId, id, user) {
        return this.subTasksService.toggleCompletion(id, taskId, user.userId);
    }
};
exports.SubTasksController = SubTasksController;
__decorate([
    (0, common_1.Get)(),
    __param(0, (0, common_1.Param)('taskId')),
    __param(1, (0, current_user_decorator_1.CurrentUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", void 0)
], SubTasksController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('taskId')),
    __param(1, (0, common_1.Param)('id')),
    __param(2, (0, current_user_decorator_1.CurrentUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, Object]),
    __metadata("design:returntype", void 0)
], SubTasksController.prototype, "findOne", null);
__decorate([
    (0, common_1.Post)(),
    __param(0, (0, common_1.Param)('taskId')),
    __param(1, (0, common_1.Body)()),
    __param(2, (0, current_user_decorator_1.CurrentUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, create_subtask_dto_1.CreateSubTaskDto, Object]),
    __metadata("design:returntype", void 0)
], SubTasksController.prototype, "create", null);
__decorate([
    (0, common_1.Patch)(':id'),
    __param(0, (0, common_1.Param)('taskId')),
    __param(1, (0, common_1.Param)('id')),
    __param(2, (0, common_1.Body)()),
    __param(3, (0, current_user_decorator_1.CurrentUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, update_subtask_dto_1.UpdateSubTaskDto, Object]),
    __metadata("design:returntype", void 0)
], SubTasksController.prototype, "update", null);
__decorate([
    (0, common_1.Delete)(':id'),
    __param(0, (0, common_1.Param)('taskId')),
    __param(1, (0, common_1.Param)('id')),
    __param(2, (0, current_user_decorator_1.CurrentUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, Object]),
    __metadata("design:returntype", void 0)
], SubTasksController.prototype, "remove", null);
__decorate([
    (0, common_1.Post)(':id/toggle'),
    __param(0, (0, common_1.Param)('taskId')),
    __param(1, (0, common_1.Param)('id')),
    __param(2, (0, current_user_decorator_1.CurrentUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, Object]),
    __metadata("design:returntype", void 0)
], SubTasksController.prototype, "toggleCompletion", null);
exports.SubTasksController = SubTasksController = __decorate([
    (0, common_1.Controller)('tasks/:taskId/subtasks'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard),
    __metadata("design:paramtypes", [subtasks_service_1.SubTasksService])
], SubTasksController);
//# sourceMappingURL=subtasks.controller.js.map