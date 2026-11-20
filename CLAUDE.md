# Nyx-AI-Translator — Project Context

## What This Is
Single-file Python CLI subtitle translator (`Nyx-AI-Translator.py`) that preserves subtitle timing, styles, and structure. Supports SRT, ASS/SSA, and VTT formats. Uses LLM providers via OpenRouter, direct APIs, or Claude CLI.

## Architecture
- **Single file**: Everything lives in `Nyx-AI-Translator.py` (~1700 lines)
- **Config**: YAML config at `~/.nyx-ai-translator/config.yaml`
- **Tests**: `tests/test_nyx_ai_translator.py` (29 tests, pytest)
- **Version**: 0.1.1 (branch `0.1.1`)

## Key Translation Pipeline
```
translate_subtitle_file()
  → extract show name + load characters.json (gender context)
  → translate_units() (chunks subtitle text)
    → translate_chunk() (dispatches to provider)
      → translate_openai_compatible() / translate_gemini() / translate_claude_cli() / etc.
        → translation_prompt() (builds system + user messages, includes gender_context)
  → apply_rtl_fixes() (swaps paired punctuation for RTL languages)
  → validate_output()
  → rebuild_subtitle()
```

## Providers
OpenAI-compatible (openrouter, openai, custom_openai), gemini, deepl, ollama, claude_cli, google_cloud, azure, free (deep-translator). Provider functions accept `gender_context=""` kwarg (except deepl/google_cloud/azure which don't use LLM prompts).

## Recent Features (v0.1.1)
1. **RTL punctuation fix**: Pre-swaps brackets `[]`, parens `()`, quotes `""«»''` for Arabic/Hebrew because subtitle renderers don't do BiDi mirroring. See `fix_rtl_punctuation()`, `apply_rtl_fixes()`.
2. **Gender-aware translation**: Injects show name or character glossary into the LLM prompt so Arabic conjugation uses correct gender. See `extract_show_name()`, `load_characters_glossary()`, `build_gender_context()`. Threaded through the entire translation pipeline via `gender_context` parameter.
3. **Claude CLI provider**: Uses `claude` CLI binary with `--model` flag. Config key: `providers.claude_cli.model`.

## Known Issues / TODO
- **Claude CLI model names**: Config value `opus-5-5` fails — Claude Code requires full ID `claude-opus-5-5`. Could add auto-prefix logic in `translate_claude_cli()`.
- **Gender-aware interactive prompt**: The interactive mode doesn't yet show/confirm the detected show name. Should add a prompt like "Detected show: X — [1] Use it [2] Enter different name [3] Skip".
- **Default model**: Still `openai/gpt-4o-mini` in default config — user may want `openai/gpt-6-luna`.
- **OpenRouter Gemini**: Current model ID is `google/gemini-3.1-pro-preview` (not `gemini-3-pro-preview`). Alias `~google/gemini-pro-latest` auto-redirects.

## Workflow Rules
- Always push commits to GitHub after making changes
- Run `python -m pytest tests/` before committing
- Never include API keys, hardcoded paths, or identifying info from user files
- Commit messages should describe the "why", not just the "what"

## File Patterns
- Subtitle filenames follow patterns like: `Show Name (2007) - S01E10 - Title.track0.ass`, `[SubGroup] Show - 05.ass`, `Show.S01E01.720p.ass`
- `characters.json` glossary goes next to subtitle files: `[{"name": "Nozomu", "gender": "male"}, ...]`
- ASS style tags (like "Zetsubou Main", "SZS") are NOT character names — multiple characters share the same style tag

## Arabic Translation Notes
- Arabic conjugates verbs, adjectives, and pronouns by gender — critical for subtitle quality
- Japanese lacks grammatical gender, making JA→AR especially prone to misgendering
- Fantasy/anime terms have specific Arabic translations hardcoded in `translation_prompt()` (e.g., party=فريق, skill=مهارة, dungeon=زنزانة)
- RTL punctuation must be pre-swapped because libass and other renderers don't mirror paired characters
