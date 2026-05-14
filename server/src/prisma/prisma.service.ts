import { Injectable, OnModuleInit, OnModuleDestroy, Logger } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(PrismaService.name);

  async onModuleInit() {
    try {
      this.logger.log('Connecting to database...');
      await this.$connect();
      this.logger.log('Database connection established');
    } catch (error) {
      this.logger.error('Failed to connect to database:', error);
      // 尝试重试连接
      for (let i = 1; i <= 3; i++) {
        this.logger.log(`Retrying connection (${i}/3)...`);
        try {
          await new Promise(resolve => setTimeout(resolve, 2000));
          await this.$connect();
          this.logger.log('Database connection established after retry');
          return;
        } catch (retryError) {
          this.logger.error(`Retry ${i} failed:`, retryError);
        }
      }
      // 所有重试都失败后，抛出错误
      throw new Error('Failed to connect to database after multiple attempts');
    }
  }

  async onModuleDestroy() {
    try {
      this.logger.log('Disconnecting from database...');
      await this.$disconnect();
      this.logger.log('Database connection closed');
    } catch (error) {
      this.logger.error('Error disconnecting from database:', error);
    }
  }
}
