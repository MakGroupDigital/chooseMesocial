
import { GoogleGenAI } from "@google/genai";

let ai: GoogleGenAI | null = null;

function getApiKey(): string | null {
  const viteKey = (import.meta as any)?.env?.VITE_GEMINI_API_KEY;
  const processKey = (process as any)?.env?.API_KEY || (process as any)?.env?.GEMINI_API_KEY;
  const key = viteKey || processKey;
  return typeof key === 'string' && key.trim().length > 0 ? key.trim() : null;
}

function getAiClient(): GoogleGenAI | null {
  if (ai) return ai;
  const apiKey = getApiKey();
  if (!apiKey) {
    return null;
  }
  ai = new GoogleGenAI({ apiKey });
  return ai;
}

export const getTalentInsight = async (playerName: string, stats: any) => {
  try {
    const client = getAiClient();
    if (!client) {
      return "Analyse indisponible pour le moment.";
    }

    const response = await client.models.generateContent({
      model: 'gemini-3-flash-preview',
      contents: `Analyze this African football talent: ${playerName}. Stats: ${JSON.stringify(stats)}. Provide a short scouting report (max 100 words) focusing on potential and fit for European clubs.`,
      config: {
        temperature: 0.7,
      },
    });
    return response.text;
  } catch (error) {
    console.error("Gemini Error:", error);
    return "Analyse indisponible pour le moment.";
  }
};

export const getMatchPredictionInsight = async (match: any) => {
  try {
    const client = getAiClient();
    if (!client) {
      return null;
    }

    const response = await client.models.generateContent({
      model: 'gemini-3-flash-preview',
      contents: `Analyze this match: ${match.teamA} vs ${match.teamB}. Based on recent performance, give a quick win probability for Team A, Draw, and Team B. Format as simple percentages.`,
    });
    return response.text;
  } catch (error) {
    return null;
  }
};
