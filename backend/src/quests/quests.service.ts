import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Quest } from './entities/quest.entity';
import { CreateQuestDto } from './dto/create-quest.dto';
import { UpdateQuestDto } from './dto/update-quest.dto';
import { UsersService } from '../users/users.service';

@Injectable()
export class QuestsService {
  constructor(
    @InjectRepository(Quest)
    private questRepository: Repository<Quest>,
    private usersService: UsersService,
  ) {}

  async create(createQuestDto: CreateQuestDto) {
    return this.questRepository.save(
      this.questRepository.create(createQuestDto),
    );
  }

  async findAll() {
    return this.questRepository.find();
  }

  async findOne(id: string) {
    return this.questRepository.findOneBy({ id });
  }

  async update(id: string, updateQuestDto: UpdateQuestDto) {
    await this.questRepository.update(id, updateQuestDto);
    return this.findOne(id);
  }

  async remove(id: string) {
    return this.questRepository.delete(id);
  }

  async completeQuest(userId: string, questId: string) {
    const quest = await this.findOne(questId);
    if (!quest) throw new NotFoundException('Quest not found');

    // In a real app, check 'PlayerQuest' to see if already completed today.
    // For MVP, we just verify and award.

    // Verification logic (calls LeetCodeService etc) would go here.
    // For now, assume simplified completion.

    const user = await this.usersService.addXp(userId, quest.rewards.xp);
    return {
      message: 'Quest Completed',
      rewards: quest.rewards,
      userUpdates: {
        level: user.level,
        xp: user.currentXp,
        stats: user.stats,
      },
    };
  }
}
