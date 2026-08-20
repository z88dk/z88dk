# `.agents` — z88dk agent material

Canonical tree for AI agent skills. **Do not duplicate** under other names.

## Layout

```text
.agents/
  README.md
  scripts/
  skills/
    cpu-8085/              # + references/opcodes.md
    cpu-z80/
    library-classic/
    library-math32/
    compiler-sccz80/
    tool-zcc/
    tool-ticks/
    target-cpm/
    style-ste-writing/
    methodology-measure/
    …
```

Each skill is `.agents/skills/<name>/SKILL.md`. The directory name equals the YAML `name:` field.
Optional `references/` for large tables (e.g. 8085 opcodes).

Claude Code and similar hosts scan **one** level under `skills/`. Do **not** add category folders (`cpu/`, `tool/`, …). Grouping lives in root `AGENTS.md`.

**Targets:** 100+ platforms live in `lib/config/*.cfg`. Do **not** add a `SKILL.md` per target unless a platform truly needs repeated agent rules. Never bulk-load platforms into context.

## Entry points

At the **repo root**:

- `.agents/` — real directory (this tree)
- `.grok` → `.agents` (symlink)
- `.claude` → `.agents` (symlink)
- `AGENTS.md` — always-on project rules + skill index

Agents must **realpath-dedupe** so following both `.grok` and `.claude` does not load the same skill twice. See root `AGENTS.md`.

## Adding a skill

1. Create `.agents/skills/<name>/SKILL.md`.
2. Set a unique `name:` that matches the directory (prefer `category-name`, e.g. `tool-foo`, `target-bar`).
3. Write a specific `description:` (triggers auto-invocation) — **narrow** so it does not fire on unrelated work.
4. Link related skills by `name` (e.g. `tool-z80asm`), or by path `.agents/skills/<name>/`.
5. Keep agent-dense: tables, commands, pitfalls — not full human manuals.
6. **Targets:** prefer cfg + wiki on demand; do not mass-create `target-*` skills.

## Source hierarchy when facts disagree

1. Built tools and sources in this checkout  
2. In-tree READMEs / man pages next to tools  
3. **CPU opcode acceptance (assembler):** `src/z80asm/dev/cpu/cpu_test_*_{ok,err}.asm` — last resort for “does z80asm accept this source line on `-m<cpu>`?” Decode line format in skill **`tool-z80asm`** (ok may be synthetic or `__z80asm__` helper, not only native ISA).  
4. Local `wiki/` drafts  
5. External blogs — last resort  

Do not bulk-read the large fixtures; `rg` the mnemonic.

## Origin

Imported from [feilipu/8085-skills](https://github.com/feilipu/8085-skills), then reorganized for multi-CPU z88dk work.
