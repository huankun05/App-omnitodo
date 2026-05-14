"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.FocusSessionsModule = void 0;
const common_1 = require("@nestjs/common");
const focus_sessions_service_1 = require("./focus-sessions.service");
const focus_sessions_controller_1 = require("./focus-sessions.controller");
const focus_sessions_repository_1 = require("./focus-sessions.repository");
let FocusSessionsModule = class FocusSessionsModule {
};
exports.FocusSessionsModule = FocusSessionsModule;
exports.FocusSessionsModule = FocusSessionsModule = __decorate([
    (0, common_1.Module)({
        providers: [focus_sessions_service_1.FocusSessionsService, focus_sessions_repository_1.FocusSessionsRepository],
        controllers: [focus_sessions_controller_1.FocusSessionsController],
        exports: [focus_sessions_service_1.FocusSessionsService],
    })
], FocusSessionsModule);
//# sourceMappingURL=focus-sessions.module.js.map