---
name: tool-zobjcopy
description: >
  z88dk-zobjcopy object file manipulator. Use for advanced object/section surgery.
---

# Tool — zobjcopy

| | |
|--|--|
| Binary | `z88dk-zobjcopy` |
| Help | bare usage / wiki Tool---zobjcopy |
| Wiki (local draft) | `wiki/tools/Tool---zobjcopy.md` |



## Condensed reference (from wiki / tree)

# Tool — zobjcopy (`z88dk-zobjcopy`)

Edit z80asm object and library files: list, rename sections/symbols, change locality, ORG/ALIGN, filler.

## Live usage text

```text
Usage: zobjcopy input [options] [output]
  -v|--verbose                          ; show what is going on
  -l|--list                             ; dump contents of file
     --hide-local                       ; in list don't show local symbols
     --hide-expr                        ; in list don't show expressions
     --hide-code                        ; in list don't show code dump
  -s|--section old-regexp=new-name      ; rename all sections that match
  -p|--add-prefix symbol-regexp,prefix  ; add prefix to all symbols that match
  -y|--symbol old-name=new-name         ; rename global and extern symbols
  -L|--local regexp                     ; make symbols that match local
  -G|--global regexp                    ; make symbols that match global
  -F|--filler nn|0xhh                   ; use nn as filler for align
  -O|--org section,nn|0xhh              ; change ORG of one section
  -A|--align section,nn|0xhh            ; change ALIGN of one section
```

## Common tasks

| Task | Flag pattern |
|------|----------------|
| Dump | `-l` / `--list` |
| Rename section | `-s old-regexp=new-name` |
| Rename symbol | `-y old=new` |
| Make local/global | `-L regexp` / `-G regexp` |
| Change ORG | `-O section,addr` |

## Related

- [Tool — z80asm](Tool---z80asm)
- [Tool — z80nm](Tool---z80nm)

## Related

- Driver front end: `tool/zcc`
- Measurement: `methodology/measure`, `tool/ticks`
