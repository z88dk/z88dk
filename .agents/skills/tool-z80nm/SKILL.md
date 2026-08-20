---
name: tool-z80nm
description: >
  z88dk-z80nm object/library symbol lister. Use to prove a symbol is in a .o/.lib after rebuild.
---

# Tool — z80nm

| | |
|--|--|
| Binary | `z88dk-z80nm` |
| Help | bare z88dk-z80nm usage |
| Wiki (local draft) | `wiki/tools/Tool---z80nm.md` |


## Common

```bash
z88dk-z80nm path/to/file.o
z88dk-z80nm lib/clibs/math32_8085.lib | rg 'fsdiv|fsadd'
```

Always pair with app `.map` after link (`zcc -m`).


## Condensed reference (from wiki / tree)

# Tool — z80nm (`z88dk-z80nm`)

List symbols and contents of a **z80asm** object or library file. Use it to prove a routine is **actually in** the `.lib` or `.o` you think you linked.

## Help path

There is no useful `-h`. Pass a library or object:

```text
z88dk-z80nm library.lib
z88dk-z80nm -a library.lib
z88dk-z80nm path/to/file.o
```

## Flags

| Flag | Meaning |
|------|---------|
| `-a` | Show all |
| `-l` | Show local symbols |
| `-e` | Show expression patches |
| `-c` | Show code dump |

## Methodology: link proof

After a library rebuild or a “this patch should help” claim:

```text
z88dk-z80nm lib/clibs/math32_8085.lib | rg 'f32_fsadd|your_symbol'
z88dk-z80nm lib/clibs/8085_crt0.lib | rg long_div
```

Also check the **program map** from `zcc … -m`:

```text
rg 'your_symbol' prog.map
```

| Outcome | Meaning |
|---------|---------|
| Symbol in `.lib` and in `.map` | Linked; can affect TIMER |
| Symbol in `.lib` only | Not pulled into this binary (no call / weak / wrong lib path) |
| Symbol in neither | Rebuild did not install what you think, or wrong name |

Confirm CPU and section sizes in the nm listing when multi-CPU libraries sit side by side (`math32.lib` vs `math32_8085.lib`).

## Related

- [Tool — ticks](Tool---ticks) (A/B and hotspots)
- [Tool — z80asm](Tool---z80asm)
- [Tool — zobjcopy](Tool---zobjcopy)

## Related

- Driver front end: `tool-zcc`
- Measurement: `methodology-measure`, `tool-ticks`
