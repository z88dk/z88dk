# z88dk target: Regnecentralen RC700 (`+cpm -subtype=rc700`)

CP/M target for the Regnecentralen RC700 / RC702 family. It is a **subtype of the
`+cpm` target**, not a standalone `+rc700`, so programs are built with:

```
zcc +cpm -subtype=rc700 -create-app -o prog prog.c
```

`appmake` packages the result as an **IMD 8" floppy image** (`--container=imd`),
directly loadable in MAME (`rc702`) or on hardware. The subtype line lives in
`lib/config/cpm.cfg`; it sets `-D__RC700__`, an 80x25 console, the RC700 block
graphics character set, the video RAM address, and links `rc700.lib`.

## What the target can do (verified 2026-07-25)

**Build & runtime**
- Compiles C/asm to an IMD floppy image (`-Cz+cpmdisk -Czrc700 -Cz--container=imd`).
- Full **classic** C library (`rc700.lib`): `stdio`, `string`, `stdlib`, `malloc`,
  math. Disk `FILE*` I/O works here via the classic CP/M FCB layer. (The newlib
  library has no file I/O on any z80 target — see ravn/z88dk #34; use the classic
  clib, which the rc700 subtype does by default.)

**Console & display**
- 80x25 text console (`generic_console` over video RAM at `RC700_DISPLAY = 0xF800`),
  with scroll / clear.
- Programmable character set: `rc700_loadfont` + `CRT_FONT` load a custom font
  (RAM chargen, SEM702-style).

**Graphics (semigraphics)**
- Low-resolution pixel plotting via the `gencon6` generic-console graphics using
  the block-graphics character set (`GRAPHICS_CHAR_SET = 127`,
  `GRAPHICS_CHAR_UNSET = 32`). Verified primitives: `plotpixel`, `pointxy`,
  `respixel`, `xorpixel` (`graphics/textpixl6.asm`). The standard `<graphics.h>`
  layer (plot/draw/line/circle) sits on top of these via the gencon model.
- Character-cell based; there is no bitmap / high-resolution mode.

**Serial (RS232 over SIO-A)**
- Classic-Serial conforming RS232 on SIO-A, exposed as the RDR/PUN devices, with
  real baud rates and parameters up to **38400 baud** (x16 divider; x1 unverified).
  See `rs232/rc700_sio.h`.

**Time**
- `clock()` returns raw ticks at **50 Hz** (`CLOCKS_PER_SEC = 50`); see
  `time/clock.asm`.

**Games**
- The classic `games` library is linked (sprite/tile helpers).

## Suggested demo

`examples/graphics/clock.c` — the standard portable analog-clock demo
(`<graphics.h>` + `clock()`/`<time.h>`) — exercises both the graphics and timing
paths and already carries CP/M-subtype build lines; it is the natural first demo
for this target. Verified to build (2026-07-25):

```
zcc +cpm -subtype=rc700 -create-app -o clock examples/graphics/clock.c
# -> clock.com + clock.imd (IMD floppy image)
```

## Caveats / not-yet

- No rc700-specific example programs ship in `examples/` yet.
- Graphics is semigraphics only (no hires bitmap).
- The subtype defaults to the classic clib; it is not wired as a dedicated
  `-compiler=llvmz80` route. clang can build classic `+cpm` via the classic
  bridges, but that path is not set up or tested specifically for the rc700
  subtype.

The most recent target work (RS232/SIO, `clock()`) was added in mid-2026.
