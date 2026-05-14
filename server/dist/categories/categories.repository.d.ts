import { PrismaService } from '../prisma/prisma.service';
import { CreateCategoryDto } from './dto/create-category.dto';
export declare class CategoriesRepository {
    private prisma;
    constructor(prisma: PrismaService);
    findAll(userId: string): import(".prisma/client").Prisma.PrismaPromise<{
        id: string;
        name: string;
        userId: string;
        color: string;
        icon: string | null;
    }[]>;
    create(createCategoryDto: CreateCategoryDto, userId: string): import(".prisma/client").Prisma.Prisma__CategoryClient<{
        id: string;
        name: string;
        userId: string;
        color: string;
        icon: string | null;
    }, never, import("@prisma/client/runtime/library").DefaultArgs>;
    remove(id: string, userId: string): import(".prisma/client").Prisma.PrismaPromise<import(".prisma/client").Prisma.BatchPayload>;
}
