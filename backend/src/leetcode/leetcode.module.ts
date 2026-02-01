import { Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { LeetCodeService } from './leetcode.service';

@Module({
  imports: [HttpModule],
  providers: [LeetCodeService],
  exports: [LeetCodeService],
})
export class LeetCodeModule {}
