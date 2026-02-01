import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { QuestsService } from './quests.service';
import { QuestsController } from './quests.controller';
import { Quest } from './entities/quest.entity';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [TypeOrmModule.forFeature([Quest]), UsersModule],
  controllers: [QuestsController],
  providers: [QuestsService],
  exports: [QuestsService, TypeOrmModule], // Export TypeOrmModule for Seeding
})
export class QuestsModule {}
