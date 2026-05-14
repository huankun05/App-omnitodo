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
exports.FocusSessionsController = void 0;
const common_1 = require("@nestjs/common");
const focus_sessions_service_1 = require("./focus-sessions.service");
const create_focus_session_dto_1 = require("./dto/create-focus-session.dto");
const update_focus_session_dto_1 = require("./dto/update-focus-session.dto");
const jwt_auth_guard_1 = require("../common/guards/jwt-auth.guard");
const current_user_decorator_1 = require("../common/decorators/current-user.decorator");
let FocusSessionsController = class FocusSessionsController {
    constructor(focusSessionsService) {
        this.focusSessionsService = focusSessionsService;
    }
    findAll(user) {
        return this.focusSessionsService.findAll(user.userId);
    }
    findStats(user) {
        return this.focusSessionsService.findStats(user.userId);
    }
    create(createFocusSessionDto, user) {
        return this.focusSessionsService.create(createFocusSessionDto, user.userId);
    }
    update(id, updateFocusSessionDto, user) {
        return this.focusSessionsService.update(id, updateFocusSessionDto, user.userId);
    }
};
exports.FocusSessionsController = FocusSessionsController;
__decorate([
    (0, common_1.Get)(),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], FocusSessionsController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)('stats'),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], FocusSessionsController.prototype, "findStats", null);
__decorate([
    (0, common_1.Post)(),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, current_user_decorator_1.CurrentUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_focus_session_dto_1.CreateFocusSessionDto, Object]),
    __metadata("design:returntype", void 0)
], FocusSessionsController.prototype, "create", null);
__decorate([
    (0, common_1.Patch)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __param(2, (0, current_user_decorator_1.CurrentUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, update_focus_session_dto_1.UpdateFocusSessionDto, Object]),
    __metadata("design:returntype", void 0)
], FocusSessionsController.prototype, "update", null);
exports.FocusSessionsController = FocusSessionsController = __decorate([
    (0, common_1.Controller)('focus-sessions'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard),
    __metadata("design:paramtypes", [focus_sessions_service_1.FocusSessionsService])
], FocusSessionsController);
//# sourceMappingURL=focus-sessions.controller.js.map