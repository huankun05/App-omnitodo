import { JwtService } from '@nestjs/jwt';
import { AuthRepository } from './auth.repository';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
export declare class AuthService {
    private readonly authRepository;
    private readonly jwtService;
    constructor(authRepository: AuthRepository, jwtService: JwtService);
    register(registerDto: RegisterDto): Promise<{
        token: string;
        userId: string;
        email: string;
        name: string;
    }>;
    login(loginDto: LoginDto): Promise<{
        token: string;
        userId: string;
        email: string;
        name: string;
    }>;
    private generateToken;
}
