import { ForbiddenException, Injectable } from '@nestjs/common';
import { PrismaService } from '../common/prisma.service';

@Injectable()
export class InterviewService {
  constructor(private prisma: PrismaService) {}

  async checkLimit(userId: string, isPremium: boolean) {
    if (isPremium) return;

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const usage = await this.prisma.usage.upsert({
      where: {
        userId_date: {
          userId,
          date: today,
        },
      },
      update: {},
      create: {
        userId,
        date: today,
        interviewsCount: 0,
      },
    });

    if (usage.interviewsCount >= 3) {
      throw new ForbiddenException(
        'Daily limit reached. Upgrade to Premium.',
      );
    }
  }

  async incrementUsage(userId: string) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    await this.prisma.usage.update({
      where: {
        userId_date: {
          userId,
          date: today,
        },
      },
      data: {
        interviewsCount: {
          increment: 1,
        },
      },
    });
  }
}
