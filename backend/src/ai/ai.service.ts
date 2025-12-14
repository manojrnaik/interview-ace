import { Injectable } from '@nestjs/common';
import OpenAI from 'openai';

@Injectable()
export class AIService {
  private client = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
  });

  async generateQuestion(role: string): Promise<string> {
    const response = await this.client.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [
        {
          role: 'system',
          content: `You are a professional interviewer for ${role}.`,
        },
        {
          role: 'user',
          content: 'Ask one interview question.',
        },
      ],
    });

    return response.choices[0].message.content;
  }
}
