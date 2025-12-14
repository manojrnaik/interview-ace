import {
  Body,
  Controller,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { AIService } from '../ai/ai.service';
import { FirebaseAuthGuard } from '../auth/firebase-auth.guard';
import { PrismaService } from '../common/prisma.service';
import { InterviewService } from './interview.service';

@Controller('interviews')
@UseGuards(FirebaseAuthGuard)
export class InterviewController {
  constructor(
    private readonly aiService: AIService,
    private readonly prisma: PrismaService,
    private readonly interviewService: InterviewService,
  ) {}

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
    // Limit check
    await this.interviewService.checkLimit(req.user.uid, req.user.isPremium);

    const evaluation = await this.aiService.evaluateAnswer(
      body.role,
      body.question,
      body.answer,
      req.user.uid,
    );

    // Save interview
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

    // Increment usage
    await this.interviewService.incrementUsage(req.user.uid);

    return evaluation;
  }
}
