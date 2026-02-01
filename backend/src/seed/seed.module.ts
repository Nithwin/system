import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SeedService } from './seed.service';
import { Quest } from '../quests/entities/quest.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Quest])],
  providers: [SeedService],
  exports: [SeedService],
})
export class SeedModule {}
