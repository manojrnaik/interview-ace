import {
  Body,
  Controller,
  Get,
  Post,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
import { AIService } from '../ai/ai.service';
import { FirebaseAuthGuard } from '../auth/firebase-auth.guard';
import { PrismaService } from '../common/prisma.service';

@Controller('interviews')
@UseGuards(FirebaseAuthGuard)
export class InterviewController {
  constructor(
    private readonly aiService: AIService,
    private readonly prisma: PrismaService,
  ) {}

  @Get('question')
  async getQuestion(@Query('role') role: string) {
    const question = await this.aiService.generateQuestion(role);
    return { question };
  }

  @Post('evaluate')
  async evaluateAnswer(
    @Req() req: any,
    @Body()
    body: {
      role: string;
      question: string;
      answer: string;
    },
  ) {
    const evaluation = await this.aiService.evaluateAnswer(
      body.role,
      body.question,
      body.answer,
    );

    await this.prisma.interview.create({
      data: {
        userId: req.user.uid,
        role: body.role,
        question: body.question,
        answer: body.answer,
        score: evaluation.score,
        feedback: evaluation.overallFeedback,
      },
    });

    return evaluation;
  }
}
