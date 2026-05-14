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
exports.ProjectsRepository = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let ProjectsRepository = class ProjectsRepository {
    constructor(prisma) {
        this.prisma = prisma;
    }
    findAll(userId) {
        return this.prisma.project.findMany({
            where: { userId },
            include: { _count: { select: { tasks: true } } },
            orderBy: { order: 'asc' },
        });
    }
    findOne(id, userId) {
        return this.prisma.project.findFirst({
            where: { id, userId },
        });
    }
    create(dto, userId) {
        return this.prisma.project.create({
            data: {
                name: dto.name,
                color: dto.color,
                icon: dto.icon,
                order: dto.order ?? 0,
                user: { connect: { id: userId } },
            },
        });
    }
    update(id, dto, userId) {
        return this.prisma.project.updateMany({
            where: { id, userId },
            data: dto,
        });
    }
    remove(id, userId) {
        return this.prisma.project.deleteMany({
            where: { id, userId },
        });
    }
};
exports.ProjectsRepository = ProjectsRepository;
exports.ProjectsRepository = ProjectsRepository = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], ProjectsRepository);
//# sourceMappingURL=projects.repository.js.map