import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

export enum QuestType {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  PENALTY = 'PENALTY',
  HIDDEN = 'HIDDEN',
}

export enum QuestDifficulty {
  E = 'E',
  D = 'D',
  C = 'C',
  B = 'B',
  A = 'A',
  S = 'S',
}

@Entity()
export class Quest {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  title: string;

  @Column()
  description: string;

  @Column({ type: 'enum', enum: QuestType })
  type: QuestType;

  @Column({ type: 'enum', enum: QuestDifficulty, default: QuestDifficulty.E })
  difficulty: QuestDifficulty;

  @Column({ type: 'jsonb' })
  requirements: {
    type: 'pushups' | 'running' | 'coding' | 'manual';
    count: number;
    verificationMethod: 'manual' | 'api' | 'ml_kit';
    metadata?: any;
  };

  @Column({ type: 'jsonb' })
  rewards: {
    xp: number;
    stats?: {
      str?: number;
      agi?: number;
      int?: number;
      vit?: number;
    };
  };

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
