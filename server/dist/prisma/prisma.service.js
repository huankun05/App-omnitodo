"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var PrismaService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.PrismaService = void 0;
const common_1 = require("@nestjs/common");
const client_1 = require("@prisma/client");
let PrismaService = PrismaService_1 = class PrismaService extends client_1.PrismaClient {
    constructor() {
        super(...arguments);
        this.logger = new common_1.Logger(PrismaService_1.name);
    }
    async onModuleInit() {
        try {
            this.logger.log('Connecting to database...');
            await this.$connect();
            this.logger.log('Database connection established');
        }
        catch (error) {
            this.logger.error('Failed to connect to database:', error);
            for (let i = 1; i <= 3; i++) {
                this.logger.log(`Retrying connection (${i}/3)...`);
                try {
                    await new Promise(resolve => setTimeout(resolve, 2000));
                    await this.$connect();
                    this.logger.log('Database connection established after retry');
                    return;
                }
                catch (retryError) {
                    this.logger.error(`Retry ${i} failed:`, retryError);
                }
            }
            throw new Error('Failed to connect to database after multiple attempts');
        }
    }
    async onModuleDestroy() {
        try {
            this.logger.log('Disconnecting from database...');
            await this.$disconnect();
            this.logger.log('Database connection closed');
        }
        catch (error) {
            this.logger.error('Error disconnecting from database:', error);
        }
    }
};
exports.PrismaService = PrismaService;
exports.PrismaService = PrismaService = PrismaService_1 = __decorate([
    (0, common_1.Injectable)()
], PrismaService);
//# sourceMappingURL=prisma.service.js.map