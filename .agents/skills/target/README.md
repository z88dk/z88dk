# Targets — on demand only

There are **100+** platforms (`lib/config/*.cfg`). Load **at most one** target skill per task.

## Skills present (named `+target` only)

| Skill | `zcc` | Notes |
|-------|-------|--------|
| `target/cpm/` | `+cpm` | Classic multi-CPU + newlib; subtypes = packaging |
| `target/rc2014/` | `+rc2014` | Default newlib; 8085 serial subtypes |
| `target/zx/` | `+zx` | Spectrum 48/128 — **not** Next |
| `target/zxn/` | `+zxn` | Spectrum Next — pairs with **`cpu-z80n`** |
| `target/sms/` | `+sms` | Master System / Game Gear |

## Any other platform

1. `lib/config/<name>.cfg`  
2. `libsrc/target/<name>/` or `libsrc/newlib/target/<name>/` if present  
3. One matching `wiki/platforms/Platform---*.md` if still needed  

Do **not** read other platforms “for context.”

## Adding a target skill later

Only if agents hit the same platform repeatedly. One directory `target/<name>/SKILL.md` with a **narrow** `description` that mentions `+name`. Keep it short (cfg card + classic/newlib + pitfalls).
