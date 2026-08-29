/* eslint-disable max-len */
// npm run lint -- --fix
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {Translate} from "@google-cloud/translate/build/src/v2";
import * as wanakana from "wanakana";
// @ts-expect-error - no official type defs
import Kuroshiro from "kuroshiro";
// @ts-expect-error - no official type defs
import KuromojiAnalyzer from "kuroshiro-analyzer-kuromoji";

const translate = new Translate();

let kuroshiroInstance: Kuroshiro | null = null;

/**
 * Romaji Translator
 *
 * Handles kanji/kana to romaji.
 */
async function getKuroshiro(): Promise<Kuroshiro> {
  if (!kuroshiroInstance) {
    const k = new Kuroshiro();
    await k.init(new KuromojiAnalyzer());
    kuroshiroInstance = k;
  }
  return kuroshiroInstance;
}

type SourceType = "japanese" | "romaji" | "english";

interface TranslateRequestData {
  text: string;
  sourceType: SourceType;
}

interface TranslateResult {
  original: string;
  sourceType: SourceType;
  english: string;
  japanese: string;
  romaji: string;
}

/**
 * KanaBus Translator
 *
 * Translation API to convey English and Japanese Kana, Kanji, and Romaji.
 *
 *
 * Request Params:
 *     'text': the input from the user
 *     'sourceType': the type of input
 *
 * Response:
 * {
 *      "original": "何",
 *      "sourceType": "japanese",
 *      "english": "what",
 *      "japanese": "何",
 *      "romaji": "nani"
 * }
 */
export const translateWord = onCall<TranslateRequestData>(
  {
    region: "us-central1",
    memory: "512MiB", // kuromoji dictionary load needs headroom over the 256MiB default
  },
  async (request): Promise<TranslateResult> => {
    const {text, sourceType} = request.data;

    if (!text || typeof text !== "string" || !text.trim()) {
      throw new HttpsError("invalid-argument", "text is required");
    }
    if (!["japanese", "romaji", "english"].includes(sourceType)) {
      throw new HttpsError(
        "invalid-argument",
        "sourceType must be japanese, romaji, or english",
      );
    }

    const kuroshiro = await getKuroshiro();
    let english = "";
    let japanese = "";
    let romaji = "";

    switch (sourceType) {
    case "japanese": {
      japanese = text;
      romaji = await kuroshiro.convert(text, {to: "romaji"});
      const [translation] = await translate.translate(text, {
        from: "ja",
        to: "en",
      });
      english = translation;
      break;
    }
    case "english": {
      english = text;
      const [translation] = await translate.translate(text, {
        from: "en",
        to: "ja",
      });
      japanese = translation;
      romaji = await kuroshiro.convert(translation, {to: "romaji"});
      break;
    }
    case "romaji": {
      // Deterministic romaji -> hiragana. NOT guaranteed to match "correct" kanji
      // orthography (see caveat above) — that needs IME-style dictionary resolution.
      const hiragana = wanakana.toHiragana(text);
      japanese = hiragana;
      romaji = text;
      const [translation] = await translate.translate(hiragana, {
        from: "ja",
        to: "en",
      });
      english = translation;
      break;
    }
    }

    return {original: text, sourceType, english, japanese, romaji};
  },
);
