import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { GoogleGenerativeAI, GenerativeModel } from '@google/generative-ai';

@Injectable()
export class GeminiService {
  private genAI: GoogleGenerativeAI;
  private model: GenerativeModel;

  constructor(private configService: ConfigService) {
    const apiKey = this.configService.get<string>('GEMINI_API_KEY') || '';
    if (!apiKey) console.warn('GEMINI_API_KEY is not set');
    this.genAI = new GoogleGenerativeAI(apiKey);
    this.model = this.genAI.getGenerativeModel({ model: 'gemini-pro' });
  }

  async generateText(prompt: string): Promise<string> {
    try {
      const result = await this.model.generateContent(prompt);
      const response = result.response;
      return response.text();
    } catch (error) {
      console.error('Gemini API Error:', error);
      return 'The System is offline. (AI Generation Failed)';
    }
  }

  async generateDailyQuestDescription(topic: string): Promise<string> {
    const prompt = `
      You are "The System" from Solo Leveling. 
      Generate a short, intimidating, and gamified description for a daily quest concerning "${topic}".
      Use terms like "Hunter", "Player", "Quest", "Reward", "Penalty".
      Keep it under 50 words.
    `;
    return this.generateText(prompt);
  }
}
