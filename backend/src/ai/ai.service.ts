import { Injectable, ForbiddenException } from '@nestjs/common';
import OpenAI from 'openai';
import { PrismaService } from '../common/prisma.service';

@Injectable()
export class AIService {
  private client: OpenAI;

  constructor(private prisma: PrismaService) {
    this.client = new OpenAI({
      apiKey: process.env.OPENAI_API_KEY,
    });
  }

  async generateQuestion(role: string): Promise<string> {
    const response = await this.client.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [
        {
          role: 'system',
          content: `You are a professional interviewer for the role of ${role}.`,
        },
        {
          role: 'user',
          content: 'Ask one clear interview question.',
        },
      ],
    });

    return response.choices[0].message.content ?? '';
  }

  async evaluateAnswer(
    role: string,
    question: string,
    answer: string,
    userId: string,
  ): Promise<{
    score: number;
    strengths: string[];
    improvements: string[];
    overallFeedback: string;
  }> {
    // Answer validation
    if (answer.length < 20) {
      throw new ForbiddenException('Answer too short for evaluation');
    }

    // Monthly token cap
    const startOfMonth = new Date();
    startOfMonth.setDate(1);
    startOfMonth.setHours(0, 0, 0, 0);

    const monthlyUsage = await this.prisma.apiUsage.aggregate({
      where: {
        userId,
        createdAt: { gte: startOfMonth },
      },
      _sum: { tokens: true },
    });

    if ((monthlyUsage._sum.tokens ?? 0) > 100_000) {
      throw new ForbiddenException('Monthly AI usage limit exceeded');
    }

    const response = await this.client.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [
        {
          role: 'system',
          content: `
You are a professional interviewer.
Evaluate the candidate answer strictly.
Return ONLY valid JSON:
{
  "score": number (1-10),
  "strengths": string[],
  "improvements": string[],
  "overallFeedback": string
}
        `,
        },
        {
          role: 'user',
          content: `
Role: ${role}
Question: ${question}
Answer: ${answer}
        `,
        },
      ],
    });

    const usageTokens = response.usage?.total_tokens ?? 0;

    await this.prisma.apiUsage.create({
      data: {
        userId,
        tokens: usageTokens,
      },
    });

    return JSON.parse(response.choices[0].message.content as string);
  }
}

