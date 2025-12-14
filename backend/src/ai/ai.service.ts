import { Injectable } from '@nestjs/common';
import OpenAI from 'openai';

@Injectable()
export class AIService {
  private client: OpenAI;

  constructor() {
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
  ): Promise<{
    score: number;
    strengths: string[];
    improvements: string[];
    overallFeedback: string;
  }> {
    const response = await this.client.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [
        {
          role: 'system',
          content: `
You are a professional interviewer.
Evaluate the candidate answer strictly.
Return ONLY valid JSON in this format:
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

    return JSON.parse(response.choices[0].message.content as string);
  }
}
