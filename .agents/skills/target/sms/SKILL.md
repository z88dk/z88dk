---
name: target-sms
description: >
  z88dk +sms only: Sega Master System / Game Gear. Classic default, newlib CLIBs,
  VDP/PSG console path, .sms/.gg packaging. Use when the task is explicitly
  +sms / Master System / Game Gear.
---

# Target — SMS / Game Gear (`+sms`)

| | |
|--|--|
| Config | `lib/config/sms.cfg` |
| Trees | classic `libsrc/target/sms/`; newlib `libsrc/newlib/target/sms/` |
| Headers | `include/arch/sms` (classic include path in cfg) |
| Wiki | `wiki/platforms/Platform---SMS.md` |
| Help | `zcc +sms -h` |

## Defaults

| Item | Value |
|------|--------|
| CLIB | classic **`default`** → `-lsms_clib -lndos` |
| SUBTYPE | **`default`** → `-Cz+sms` → **`.sms`** |
| Defines | `__SMS`, `__Z80` |

Bare `zcc +sms …` is **classic**.

## Classic vs newlib

| World | Select | Link / CRT |
|-------|--------|------------|
| Classic | default | `-lsms_clib`, classic `sms_crt0` |
| Newlib | `-clib=new` / `sdcc_ix` / `sdcc_iy` | `-lsms`, `sms_crt.asm.m4` |

Wiki smoke note: newlib CLIBs exist; **minimal `printf` may not link** (`_stdout`) on a bare program — use newlib SMS examples / CRT that instantiates stdio, not assume classic drop-in.

## Subtypes

| Subtype | Role |
|---------|------|
| `default` | Master System ROM via `+sms` |
| **`gamegear`** | `-Cz+sms -Cz-e -Cz.gg` + `__GAMEGEAR__` → **`.gg`** |
| `none` | no packaging |

Aliases: `--smslib`, `--smslib-md` (pragma defines for SMSlib-style builds).

## Hardware (agent-relevant)

| Item | Spec |
|------|------|
| CPU | Z80 ~3.58 MHz |
| RAM | 8 KiB |
| Video | VDP (TMS-class), 16 KiB VRAM |
| Sound | SN76489 PSG |
| Classic lib | gencon / hires gfx / PSG / joystick / interrupts (see wiki checklist) |
| File I/O | generally **no** classic disk stack |

SMSlib notes: `libsrc/target/sms/SMSlib/README.md` when using that stack.

## Recipes

```text
zcc +sms -vn game.c -o game -create-app           # .sms
zcc +sms -subtype=gamegear -create-app -vn …
zcc +sms -clib=sdcc_iy -create-app …              # newlib; watch CRT/stdio
```

## Agent notes

1. Not Spectrum — no TAP/NEX recipes.  
2. Prefer classic for console/graphics samples under `examples/sms/`.  
3. Related: `cpu-z80`, `library-classic`, `tool-appmake`.
