import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DeepPartial } from 'typeorm';
import {
  Quest,
  QuestType,
  QuestDifficulty,
} from '../quests/entities/quest.entity';

@Injectable()
export class SeedService implements OnModuleInit {
  constructor(
    @InjectRepository(Quest)
    private questRepository: Repository<Quest>,
  ) {}

  async onModuleInit() {
    await this.seedQuests();
  }

  async seedQuests() {
    const count = await this.questRepository.count();
    if (count > 0) return; // Already seeded

    console.log('Seeding initial quests...');

    const quests = [
      {
        title: 'Pushup Mastery I',
        description:
          'Complete 50 Pushups. Failure to complete will result in a penalty.',
        type: QuestType.DAILY,
        difficulty: QuestDifficulty.E,
        requirements: {
          type: 'pushups',
          count: 50,
          verificationMethod: 'manual',
        },
        rewards: { xp: 50, stats: { str: 1 } },
      },
      {
        title: 'Running: The First 5k',
        description: 'Run 5 kilometers. Improve your agility.',
        type: QuestType.DAILY,
        difficulty: QuestDifficulty.D,
        requirements: {
          type: 'running',
          count: 5000,
          verificationMethod: 'api',
        }, // 5000 meters
        rewards: { xp: 100, stats: { agi: 2 } },
      },
      {
        title: 'Algorithm Proficiency',
        description: 'Solve 1 LeetCode Easy Problem. Sharpen your mind.',
        type: QuestType.DAILY,
        difficulty: QuestDifficulty.E,
        requirements: { type: 'coding', count: 1, verificationMethod: 'api' },
        rewards: { xp: 75, stats: { int: 1 } },
      },
      {
        title: 'SURVIVAL',
        description:
          'PENALTY QUEST. Survive in the dead zone. Keep moving for 30 minutes.',
        type: QuestType.PENALTY,
        difficulty: QuestDifficulty.A,
        requirements: {
          type: 'manual',
          count: 30,
          verificationMethod: 'manual',
        }, // 30 mins
        rewards: { xp: 0 },
      },
    ];

    for (const q of quests) {
      await this.questRepository.save(
        this.questRepository.create(q as DeepPartial<Quest>),
      );
    }

    console.log('Quests seeded successfully.');
  }
}
