# z88dk-ticks paging

The program counter stays 16 bits. A loaded file stays at most 64 kB.
`-output` writes 64 kB through the map at the end of the run.
With `-b rc2014`, `-output` also writes the ROM and both RAM pages after the register block.

ZX Next banking stays as described in [rabbit-memory.md](rabbit-memory.md).
`-mz80n` selects that model when you do not pass `-b`.

## Z180

`-mz180` selects the Z180 memory model when you do not pass `-b`.
An explicit `-b` wins, including `-b standard`.
The order of the two flags does not matter.

Physical memory is 1 MB.
Reset values are CBAR `0xF0`, BBR `0`, CBR `0`, and ICR `0`.
With those values each logical address is the same physical address in the low 64 kB.
A program that does not write the MMU keeps the old tick counts.

The loader also copies that 64 kB to physical address `0xF0000`.
The SCZ180 preamble sets CBAR to `0xE0` and CBR to `0xF0`.
Logical addresses `0xE000` to `0xFFFF` then read that copy.
A write in one store leaves the other store unchanged.
Any other bank reads as 0 until the program writes it.
The YAZ180 preamble leaves CBAR at `0xF0` and CBR at 0, so that program still sees the loaded image.
A later BBR value selects a bank the loader did not fill.

For logical page `P = address >> 12`:

- `P < CBAR[3:0]`: common area 0, base 0
- else `P < CBAR[7:4]`: bank area, base BBR
- else: common area 1, base CBR

Physical bits 19–12 are `(base + P) mod 256`.
Bits 11–0 are the logical bits.

Page F (`0xF000`–`0xFFFF`) is always common area 1.
Code that writes BBR runs from page F with CBR at 0.
Code that writes CBR does not run from page F.
Put CBAR, BBR, and CBR back before the program stops.
`-output` uses the final map.

`in0` and `out0` do I/O.
`in0` takes 12 states and sets flags the same way as `in r,(c)`.
`out0` takes 13 states.
`out (c),r` and `out (n),a` use the same decoder.

ICR bits 7–6 place the 64 internal registers at `0x00`, `0x40`, `0x80`, or `0xC0`.
The low 8 bits of the port are the address.
The high byte is not compared.

| Offset | Register |
|--------|----------|
| `0x38` | CBR |
| `0x39` | BBR |
| `0x3A` | CBAR |
| `0x3F` | ICR |

YAZ180 leaves ICR at 0, so BBR is port `0x39`.
SCZ180 sets ICR to `0xC0`, so BBR is port `0xF9`.
The other on-chip peripherals are not modelled.

`-mez80_z80` executes `in0` and `out0`.
It does not select the Z180 memory model.
`ED 28` is `in0 l,(n)` on the Z180 only.
On `-mez80_z80` that opcode takes 8 states and leaves the next byte to be fetched.

## RC2014

Pass `-b rc2014`.
`-mz80` does not select this model.
A file name that contains `rc2014` plants the hook traps only for a RAM program.

Port `0x38` is the standard 32 kB ROM page.
Every pageable ROM RC2014 uses it.
Data bit 0 selects the window:

- 0 maps the ROM over `0x0000`–`0x7FFF` for reads
- 1 maps RAM there

An empty ROM byte reads as `0xFF`.
A write in the window goes to RAM and leaves the ROM byte unchanged.
Code that turns the ROM on runs from `0x8000` or above.
`-romsize` does not block that write.

A file of at most 32 kB, loaded at address 0, is the ROM image.
ticks stores that file in the ROM.
Bytes past the end of the file read as `0xFF`.
Both RAM pages start clear.
The ROM is on and the program counter is 0.
This load does not plant the hook traps.

A longer file is a RAM program.
The RAM program starts with the ROM off.
ticks writes that image to both RAM pages, so the instruction after an `out` to port `0x30` is present.
A later store goes to the selected page only.

Port `0x30` is shadow RAM.
Only the SC108, the Memory Module, and the other 128 kB RAM boards have it.
Data bit 0 selects one of two 64 kB pages.
The other data bits are ignored.
The port is write-only.
Reset selects page 0.

An `out` to port `0x30` switches the whole 64 kB.
The next instruction comes from the other page.
`-output` reads the final page.
The ROM image is 32 kB and starts at file offset `0x11000`.
RAM page 0 is 64 kB and starts at offset `0x19000`.
RAM page 1 is 64 kB and starts at offset `0x29000`.

`-disk` loads images into the RC2014 stores.
Pass `-b rc2014` with `-disk`.

```text
z88dk-ticks -m8085 -b rc2014 -disk rom.bin ram.bin
```

The first file is the ROM image.
ticks writes that file at the start of the 32 kB ROM.
The file is at most 32 kB.
Bytes past the end of the file read as `0xFF`.
The second file is the RAM image for page 0.
ticks writes that file at the start of the 64 kB page.
The file is at most 64 kB.
A third file is the RAM image for page 1.
Page 1 stays clear when that file is absent.
The RAM images stay out of the ROM store.
Execution starts at address 0 in the ROM.
`-pc` selects another start address.
ticks turns the ROM on and selects page 0.
The hook traps stay off.
`-disk` does not take another input file.
One file of at most 32 kB loaded at 0 remains the firmware start.

## Bank images

`-banks` loads `<name>_BANK_nn.bin` for the Rabbit, the ZX Next, and the MSX.
The Z180 and the RC2014 do not use those files.

## Tests

Run `make -C test/suites/ticks_page`.

The suite checks the Z180 map and `-b standard` with `-mz180`.
It checks the SCZ180 common-1 window.
It checks the RC2014 ROM page and shadow RAM on the Z80 and the 8085.
It checks the firmware start, and `-romsize` on the ROM page.
It checks an 8085 ROM image and RAM image (`-disk`).
It checks `ED 28` on `-mez80_z80`.
It checks the ZX Next MMU.
The shell recipes do not run on Windows.

Before it writes the hotspot list, ticks restores the map from after the load.
The Z180 list uses CBAR `0xF0`, BBR 0, CBR 0, and ICR 0.
An RC2014 RAM program lists with the ROM off.
An RC2014 firmware image lists from the ROM.
A disk image lists from the ROM.
