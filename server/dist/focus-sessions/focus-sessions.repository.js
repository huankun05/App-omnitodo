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
exports.FocusSessionsRepository = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let FocusSessionsRepository = class FocusSessionsRepository {
    constructor(prisma) {
        this.prisma = prisma;
    }
    findAll(userId) {
        return this.prisma.focusSession.findMany({
            where: { userId },
            orderBy: { startTime: 'desc' },
        });
    }
    async findStats(userId) {
        const sessions = await this.prisma.focusSession.findMany({
            where: { userId },
        });
        const totalSessions = sessions.length;
        const completedSessions = sessions.filter(s => s.completed).length;
        const totalMinutes = sessions.reduce((acc, s) => acc + s.duration, 0);
        const completionRate = totalSessions > 0 ? Math.round((completedSessions / totalSessions) * 100) : 0;
        return {
            totalSessions,
            totalMinutes,
            completionRate,
        };
    }
    create(createFocusSessionDto, userId) {
        return this.prisma.focusSession.create({
            data: {
                ...createFocusSessionDto,
                userId,
            },
        });
    }
    update(id, updateFocusSessionDto, userId) {
        return this.prisma.focusSession.updateMany({
            where: { id, userId },
            data: updateFocusSessionDto,
        }).then(() => this.prisma.focusSession.findFirst({ where: { id, userId } }));
    }
};
exports.FocusSessionsRepository = FocusSessionsRepository;
exports.FocusSessionsRepository = FocusSessionsRepository = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], FocusSessionsRepository);
//# sourceMappingURL=focus-sessions.repository.js.map