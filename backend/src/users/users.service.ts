import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DeepPartial } from 'typeorm';
import { User, Rank } from './entities/user.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,
  ) {}

  async create(userData: DeepPartial<User>): Promise<User> {
    const user = this.usersRepository.create(userData);
    return this.usersRepository.save(user);
  }

  async findOneByEmail(email: string): Promise<User | null> {
    return this.usersRepository.findOneBy({ email });
  }

  async findOne(id: string): Promise<User | null> {
    return this.usersRepository.findOneBy({ id });
  }

  async addXp(userId: string, amount: number): Promise<User> {
    const user = await this.findOne(userId);
    if (!user) throw new Error('User not found');

    user.currentXp += amount;

    // Level up logic
    while (user.currentXp >= user.xpToNextLevel) {
      user.currentXp -= user.xpToNextLevel;
      user.level += 1;
      user.xpToNextLevel = Math.floor(user.xpToNextLevel * 1.2); // 20% increase

      // Stat boost on level up
      // In a real game, user chooses. Here we auto-increment for now.
      user.stats.str += 1;
      user.stats.agi += 1;
      user.stats.int += 1;
      user.stats.vit += 1;
      user.stats.per += 1;

      // Unlocks based on level (simplified)
      if (user.level >= 10 && user.rank === Rank.E) user.rank = Rank.D;
      if (user.level >= 20 && user.rank === Rank.D) user.rank = Rank.C;
    }

    return this.usersRepository.save(user);
  }
}
