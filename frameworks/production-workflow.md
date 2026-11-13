# Production workflow (overrides CLAUDE.md §5.5)

Decided by the director on 2026-11-12:

- **Visuals:** built in this repo as silent, caption-free videos (`tools/studio/`, output in `renders/clean/`).
- **Voiceover and captions:** added by the director in **CapCut**. Claude cannot operate CapCut, so Claude prepares the files and the director does the CapCut steps.
- **Handoff:** `briefs/capcut-handoff.md` has the steps. Voiceover text is in `briefs/vo/###-vo.txt`.
- **Paid features:** some CapCut voices and tools need a paid plan. That is the director's call inside CapCut.
- **Updated 2026-11-13:** the director turned the toolkit workflow back on. Polished Reels are built with Remotion, the toolkit's renderer, in `tools/reel/`. Voice and captions stay in CapCut, with the male "sly villain" voice. Full system: `frameworks/production-system.md`.
