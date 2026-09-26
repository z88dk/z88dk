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

## RC702 data-diskette formats (ravn/z88dk #36)

`+cpmdisk` now ships two RC702 data-diskette formats whose emitted `.imd`
physically matches the real diskettes, including the mixed-density **Track 0**
(FM 128 B on side 0 + MFM 256 B on side 1) that a single uniform `disc_spec`
could not previously express:

| Format `-f` | Geometry | Track 0 (side 0 / side 1) | Data tracks |
|---|---|---|---|
| `rc700-5dd` | 5.25" DS/DD, 36 cyl | FM 16x128 / MFM 16x256 | MFM 9x512 |
| `rc700-8dd` | 8" DS/DD, 77 cyl | FM 26x128 / MFM 26x256 | MFM 15x512 |

```
z88dk-appmake +cpmdisk -f rc700-8dd --container imd -b app.bin -o disk.imd
```

Cross-check the result against the preserved reference diskettes with
`imdinfo.py` (rc700-gensmedet): the geometry lines match `SW1711-I8.imd` (8")
and `RC702_TEST_v1.2.imd` (5.25").

**These are data diskettes, not bootable system disks by default.** Tracks 0–1
are zero-filled (`boot_zero_tracks`), so RC702 autoload finds no ` RC702`/
` RC700` signature in Track 0 and does not treat the disk as bootable.

To make one **bootable**, pass the boot region with `-s <bootfile>`. For these
mixed-density formats `-s` operates at **sector level**: the payload is the boot
region's sectors in physical `(track, side, sector-ID)` order, spliced in with
each track/side's native density (Track 0 = FM 128 B side 0 / MFM 256 B side 1),
so a real RC702 Track 0 can be injected verbatim. The boot region is 25 344 B
for 8" DD (T0S0 26x128 + T0S1 26x256 + T1S0 15x512 + T1S1 15x512) and 15 360 B
for 5.25" DD; a shorter payload leaves the rest zero-filled.

The RC702 boot track is the proprietary DRI CP/M cold-boot loader and is **not**
freely redistributable, so it is not bundled here — extract it from a licensed
reference RC702 boot diskette IMD you already hold (e.g. `SW1711-I8.imd`) by
concatenating its Tracks 0–1 sectors in `(track, side, sector-ID)` order:

```
# build a data diskette (Tracks 0-1 zeroed)
z88dk-appmake +cpmdisk -f rc700-8dd --container imd -b app.bin -o data.imd

# build a bootable diskette from a licensed reference boot region
z88dk-appmake +cpmdisk -f rc700-8dd --container imd -b app.bin -s boot01.bin -o sys.imd
```

Cross-check the geometry with `imdinfo.py` (rc700-gensmedet): the lines match
`SW1711-I8.imd` (8") and `RC702_TEST_v1.2.imd` (5.25"); with a real boot region
Track 0 also reports the CP/M sign-on. See ravn/z88dk #61 for the sector-level
`-s` mechanism. The single-density `rc700-8sd` (IBM-3740 8" SS/SD) and
`rc703-qd` (5.25" QD) formats are uniform and need no mixed-density Track 0.

## Caveats / not-yet

- **The `rc700` *subtype* build (`zcc +cpm -subtype=rc700`) still emits the
  legacy uniform `rc700_spec`** (9x512 MFM throughout) — a plain data image, not
  the mixed-density format above. Use `+cpmdisk -f rc700-8dd`/`rc700-5dd` for a
  physically-correct RC702 data diskette. See ravn/z88dk **#36**.
- No rc700-specific example programs ship in `examples/` yet.
- Graphics is semigraphics only (no hires bitmap).
- The subtype defaults to the classic clib; it is not wired as a dedicated
  `-compiler=llvmz80` route. clang can build classic `+cpm` via the classic
  bridges, but that path is not set up or tested specifically for the rc700
  subtype.

The most recent target work (RS232/SIO, `clock()`) was added in mid-2026.
