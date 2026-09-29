# z88dk — Copilot

z88dk is a Z80-family C toolchain. The built tools are in `bin/`. `ZCCCFG` is `lib/config`. Use those binaries unless the task is to build the toolchain.

`AGENTS.md` at the repository root is the full rule set and the skill index. Read it before a change that is wider than a comment or a typo. When this file and `AGENTS.md` disagree, follow `AGENTS.md`. When the wiki and the tree disagree, follow the tree.

## Skills

Skills are `.agents/skills/<name>/SKILL.md`. `.claude` and `.grok` are the same directory. Read a skill once.

Before you edit, read the one skill whose description matches the task. Use the index in `AGENTS.md` to choose it. Do not open every skill, every CPU skill, or `target/` and `wiki/platforms/` in bulk.

Open a target skill only when the task names that `+target`. For any other machine, read `lib/config/<name>.cfg` and that machine's sources.

Do not add `CLAUDE.md` or a second copy of these rules.

## House rules

1. In `libsrc/`, one major function per source file. Read `style-libsrc-layout` before you add or split a library file.
2. Hand-written library asm is assembled as written. `z88dk-copt` does not run on it. Read `tool-copt` before you clean that asm.
3. Keep classic and newlib stdio apart. Read `library-classic` or `library-newlib` before you touch either core.
4. Write Zilog mnemonics in this tree. Read the matching `cpu-*` skill before you write or review asm for that CPU.
5. On 8085, use the extended ops. Keep locals and intermediates on the stack. Read `cpu-8085`.
6. Measure with `z88dk-ticks`. Put the CPU flag before the binary. Read `tool-ticks` and `methodology-measure`.
7. From v2.5, `-lm` is math32 on classic and newlib. `+zx81` and `+lambda` `-lm` stay `genmath_zx81`. ROM maths stays `-lmz`. math32 divide is restoring. math32 inverse is Newton–Raphson. Read `library-math32` or `library-math16` before you edit those cores.
8. To see whether z80asm accepts one source line, search `src/z80asm/dev/cpu/cpu_test_<cpu>_ok.asm` or `_err.asm` for that mnemonic. Read `tool-z80asm` for the line format. Do not load a whole `*_err.asm`.

## Prose

Read `.agents/skills/style-ste-writing/SKILL.md` before you write or rewrite comments, PR text, review comments, commit-message discussion, wiki text, READMEs, error messages, or release notes.

Use STE-flavored prose for that text. Use strict STE for procedures and error messages. Do not apply STE to code, identifiers, or command lines.

Write active voice, British spelling, and one fact per sentence. Keep a sentence under 25 words. Do not use a semicolon or a contraction. Use one name for one thing.

A code comment states a constraint the next reader cannot see from the instruction. Do not narrate the edit. Do not add a banner, a TODO for unrelated work, or a restatement of the code.

A PR description states what changed, why, and how you tested it. Omit praise, a change log of every file, and a model credit.

Review comments name the file, the defect, and the correction. One comment per defect.

## Git and scope

Commit only when asked. One subject line, no body. No `Co-Authored-By` and no "generated with" trailer.

Do not stage `.DS_Store`, `._*`, `.fseventsd`, `.Spotlight-V100`, `.Trashes`, or `.TemporaryItems`.

Change only the lines the task names. Leave unrelated files as they are. Do not push unless asked.
