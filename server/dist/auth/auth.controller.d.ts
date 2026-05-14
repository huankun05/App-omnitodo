import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
export declare class AuthController {
    private readonly authService;
    constructor(authService: AuthService);
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
}
