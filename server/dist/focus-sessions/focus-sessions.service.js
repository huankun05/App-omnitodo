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
exports.FocusSessionsService = void 0;
const common_1 = require("@nestjs/common");
const focus_sessions_repository_1 = require("./focus-sessions.repository");
let FocusSessionsService = class FocusSessionsService {
    constructor(focusSessionsRepository) {
        this.focusSessionsRepository = focusSessionsRepository;
    }
    findAll(userId) {
        return this.focusSessionsRepository.findAll(userId);
    }
    findStats(userId) {
        return this.focusSessionsRepository.findStats(userId);
    }
    create(createFocusSessionDto, userId) {
        return this.focusSessionsRepository.create(createFocusSessionDto, userId);
    }
    update(id, updateFocusSessionDto, userId) {
        return this.focusSessionsRepository.update(id, updateFocusSessionDto, userId);
    }
};
exports.FocusSessionsService = FocusSessionsService;
exports.FocusSessionsService = FocusSessionsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [focus_sessions_repository_1.FocusSessionsRepository])
], FocusSessionsService);
//# sourceMappingURL=focus-sessions.service.js.map