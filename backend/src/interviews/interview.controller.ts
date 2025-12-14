import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { AIService } from '../ai/ai.service';
import { FirebaseAuthGuard } from '../auth/firebase-auth.guard';

@Controller('interviews')
@UseGuards(FirebaseAuthGuard)
export class InterviewController {
  constructor(private aiService: AIService) {}

  @Get('question')
  async getQuestion(@Query('role') role: string) {
    const question = await this.aiService.generateQuestion(role);
    return { question };
  }
}
