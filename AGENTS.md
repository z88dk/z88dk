# z88dk — agent instructions

Project rules for AI agents (Grok, Claude, Cursor, and similar) working in this tree.
Seeded from [feilipu/8085-skills](https://github.com/feilipu/8085-skills); reorganized for z88dk.

## Canonical skill root (do not double-read)

| Path | Role |
|------|------|
| **`.agents/`** | **Only** real tree of agent skills and notes |
| **`.grok`** | Symlink → `.agents` (Grok discovery) |
| **`.claude`** | Symlink → `.agents` (Claude discovery) |

**Rules**

1. Prefer paths under **`.agents/skills/...`** in prose and links.
2. Before loading a skill file, **resolve realpath**. If that realpath was already loaded via `.grok` or `.claude`, **do not read it again**.
3. Skill `name` values are globally unique (`cpu-8085`, `tool-ticks`, …). Hosts that dedupe by name still must not re-apply the same body under another alias.
4. Do **not** add a second full instruction set as root `CLAUDE.md` or `.agents/CLAUDE.md` that duplicates this file or the skills.
5. This **`AGENTS.md`** is the only always-on project rules file at the repo root.

Skills load **on demand** when the task matches their `description`.

**Context budget (mandatory)**

1. Do **not** bulk-read every skill under `.agents/skills/`.
2. Do **not** open every tool or every CPU skill “just in case.”
3. **Targets:** there is **no** per-platform skill set. There are 100+ machines. Never walk `target/` or `wiki/platforms/` in bulk. See **Targets** below.
4. The index tables in this file are enough to *choose* a skill; open a `SKILL.md` only when that topic is in scope.

## Environment

```bash
export PATH=/path/to/z88dk/bin:$PATH
export ZCCCFG=/path/to/z88dk/lib/config
```

Assume a built tree (`bin/` tools present) unless the task is to build the toolchain.

## Hard house rules (always)

1. **`libsrc/`**: one major function / logical operation per source file (`style-libsrc-layout`).
2. **Hand-written library asm** is assembled as-is — **`z88dk-copt` never runs on it** (`tool-copt`).
3. **Classic vs newlib**: do not merge stdio/fcntl cores in one link without a designed bridge (`library-classic`, `library-newlib`).
4. **Mnemonics:** **Zilog everywhere** in the z88dk tree. z80asm may accept **Intel** forms on 8080/8085 for **external-code compatibility only** — do not write Intel mnemonics in z88dk sources (`cpu-8085`, `tool-z80asm`).
5. **8085:** extended ops and **stack-only** locals (`cpu-8085`).
6. **Measure** with `z88dk-ticks`; put **CPU flag before the binary** (`tool-ticks`, `methodology-measure`).
7. **math32 / math16**: `div` = restoring; `inv` = Newton–Raphson (`library-math32`, `library-math16`).
8. **CPU opcode capability (last resort):** fixtures in `src/z80asm/dev/cpu/` (`cpu_test_<cpu>_ok.asm` / `_err.asm`) answer “does **z80asm** accept this **source line** for `-m<cpu>`, and what does it emit?” **ok** may be native, multi-byte synthetic, or `call __z80asm__*`. **`_strict_`** = strict mode (**synthetics forbidden**). Fixtures may list Intel spellings for compat tests; emit **Zilog** in tree work. How to read lines: skill **`tool-z80asm`**. `rg` one mnemonic; never bulk-load huge `*_err.asm` files.

## Commit hygiene

1. **One subject line. No body.** Commit with a single `-m`. Backend work uses
   `80cc: <lowercase declarative sentence>`, e.g. `80cc: a constant-count byte
   right shift stays in the accumulator`.
2. **No attribution trailers.** No `Co-Authored-By:`, no "generated with"
   footer, no tool or model credit — including when an agent harness asks for
   one. This rule wins.
3. Rationale, measurements and validation belong in the code comments, the
   `*_PLAN.md` / handover notes, or the PR description — not the commit message.
4. Commit only when asked, and never push unasked.

## Skill index

Load only what the task needs. Paths are under `.agents/skills/`.

Each skill lives at `.agents/skills/<name>/SKILL.md`. The directory name is the `name:` field. Hosts that scan only one level under `skills/` need this flat layout. Do **not** add category folders.

### CPU

| Skill | When |
|-------|------|
| `cpu-8085` | 8085 asm, opcodes, stack rules, extended ops |
| `cpu-z80` | Z80 IX/IY/exx library asm |
| `cpu-z80n` | Next Z80N ops, nextreg, copper; `+zxn` / math32_z80n |
| `cpu-z180` | Z180 / mlt / related products |
| `cpu-8080` | 8080 (no 8085 extended) |
| `cpu-gbz80` | Game Boy CPU path |

### Library

| Skill | When |
|-------|------|
| `library-classic` | Classic clib, multi-CPU, hybrid consoles |
| `library-newlib` | CRT m4, FILE*, open, dual-stack |
| `library-math32` | IEEE float cores, multi-CPU rebuild |
| `library-math16` | Half float |
| `library-am9511` | Am9511A APU float, status/specials, techdocs |

### Compiler

| Skill | When |
|-------|------|
| `compiler-sccz80` | sccz80 + runtime + copt interaction |
| `compiler-zsdcc` | zsdcc / sdcc_ix / sdcc_iy / patch pin |
| `compiler-80cc` | 80cc, Z80 `-fframe-pointer`, #3066 |

### Tools

| Skill | Binary / topic |
|-------|----------------|
| `tool-zcc` | `zcc` |
| `tool-ticks` | `z88dk-ticks` |
| `tool-z80asm` | `z88dk-z80asm` |
| `tool-copt` | `z88dk-copt` / hand-asm hygiene |
| `tool-z80nm` | `z88dk-z80nm` |
| `tool-dis` | `z88dk-dis` |
| `tool-appmake` | `z88dk-appmake` |
| `tool-zobjcopy` | `z88dk-zobjcopy` |
| `tool-z88dk-lib` | `z88dk-lib` |
| `tool-gdb` | `z88dk-gdb` |
| `tool-zx0` / `tool-zx7` | compressors |
| `tool-ucpp` / `tool-zpragma` | usually via zcc only |
| `tool-asmpp` / `tool-asmstyle` / `tool-basck` | niche helpers |

### Targets (load only the named `+target`)

**Do not** bulk-load target skills or walk all platforms. Open **one** skill when the task names that machine.

| Skill | `zcc` |
|-------|-------|
| `target-cpm` | `+cpm` |
| `target-rc2014` | `+rc2014` |
| `target-zx` | `+zx` (48/128, not Next) |
| `target-zxn` | `+zxn` (Next; see also `cpu-z80n`) |
| `target-sms` | `+sms` / Game Gear |

**Any other target:** `lib/config/<name>.cfg` (+ optional `libsrc/target/<name>/` or `libsrc/newlib/target/<name>/`, and one `wiki/platforms/` page). No skill pack for the remaining 100+. Do not read other platforms for context.

**Add a target skill later** only when agents hit the same platform repeatedly. One directory `.agents/skills/target-<name>/` with a narrow `description` that mentions `+name`. Keep it short (cfg card + classic/newlib + pitfalls).

Host TIMER / suites: `+test` + `methodology-measure` / `tool-ticks`.

### Style and methodology

| Skill | When |
|-------|------|
| `style-libsrc-layout` | New or split library files |
| `style-ste-writing` | Human prose only (not code) |
| `methodology-measure` | A/B, hotspots, z88dk benches, suites, wiki numbers |
| `methodology-sdcc-vanilla` | Stock `sdcc` benches (`*/sdcc/`), not zsdcc |

## Human docs vs agent skills

| Audience | Location |
|----------|----------|
| Agents | `.agents/skills/<name>/SKILL.md`, this file |
| Humans (wiki drafts) | `wiki/` |
| Product library notes | e.g. `libsrc/math/float/math32/readme.md` |

When wiki and tree disagree, **the tree wins**.

## Provenance

Initial content imported from local `8085-skills` (`.grok/skills/*`), then split and expanded with `wiki/tools`, `wiki/platforms`, tool READMEs, and `lib/config`.
