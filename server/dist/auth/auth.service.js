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
exports.AuthService = void 0;
const common_1 = require("@nestjs/common");
const jwt_1 = require("@nestjs/jwt");
const bcrypt = require("bcryptjs");
const auth_repository_1 = require("./auth.repository");
let AuthService = class AuthService {
    constructor(authRepository, jwtService) {
        this.authRepository = authRepository;
        this.jwtService = jwtService;
    }
    async register(registerDto) {
        const existingUser = await this.authRepository.findByEmail(registerDto.email);
        if (existingUser) {
            throw new common_1.ConflictException('Email already exists');
        }
        const hashedPassword = await bcrypt.hash(registerDto.password, 10);
        const user = await this.authRepository.create({
            ...registerDto,
            password: hashedPassword,
        });
        const token = this.generateToken(user.id, user.email);
        return {
            token,
            userId: user.id,
            email: user.email,
            name: user.name,
        };
    }
    async login(loginDto) {
        const user = await this.authRepository.findByEmail(loginDto.email);
        if (!user) {
            throw new common_1.UnauthorizedException({ code: 'USER_NOT_FOUND', message: 'No account found with this email address.' });
        }
        const isPasswordValid = await bcrypt.compare(loginDto.password, user.password);
        if (!isPasswordValid) {
            throw new common_1.UnauthorizedException({ code: 'INVALID_PASSWORD', message: 'Incorrect password. Please try again.' });
        }
        const token = this.generateToken(user.id, user.email);
        return {
            token,
            userId: user.id,
            email: user.email,
            name: user.name,
        };
    }
    generateToken(userId, email) {
        return this.jwtService.sign({ sub: userId, email });
    }
};
exports.AuthService = AuthService;
exports.AuthService = AuthService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [auth_repository_1.AuthRepository,
        jwt_1.JwtService])
], AuthService);
//# sourceMappingURL=auth.service.js.map