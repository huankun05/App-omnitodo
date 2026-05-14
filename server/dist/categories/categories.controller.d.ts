import { CategoriesService } from './categories.service';
import { CreateCategoryDto } from './dto/create-category.dto';
export declare class CategoriesController {
    private readonly categoriesService;
    constructor(categoriesService: CategoriesService);
    findAll(user: any): import(".prisma/client").Prisma.PrismaPromise<{
        id: string;
        name: string;
        userId: string;
        color: string;
        icon: string | null;
    }[]>;
    create(createCategoryDto: CreateCategoryDto, user: any): import(".prisma/client").Prisma.Prisma__CategoryClient<{
        id: string;
        name: string;
        userId: string;
        color: string;
        icon: string | null;
    }, never, import("@prisma/client/runtime/library").DefaultArgs>;
    remove(id: string, user: any): import(".prisma/client").Prisma.PrismaPromise<import(".prisma/client").Prisma.BatchPayload>;
}
