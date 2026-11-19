# z88dk-ticks paging

The program counter stays 16 bits. A loaded file stays at most 64 kB.
`-output` writes 64 kB through the map at the end of the run.

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

## RC2014

Pass `-b rc2014`.
`-mz80` does not select this model.
A file name that contains `rc2014` only plants the hook traps.

Port `0x38` is the standard 32 kB ROM page.
Every pageable ROM RC2014 uses it.
Data bit 0 selects the window:

- 0 maps the ROM over `0x0000`–`0x7FFF` for reads
- 1 maps RAM there

Reset leaves the ROM off, so the loaded program runs from RAM.
An empty ROM byte reads as `0xFF`.
A write in the window goes to RAM.
Code that turns the ROM on runs from `0x8000` or above.

Port `0x30` is shadow RAM.
Only the SC108, the Memory Module, and the other 128 kB RAM boards have it.
Data bit 0 selects one of two 64 kB pages.
The other data bits are ignored.
The port is write-only.
Reset selects page 0.

An `out` to port `0x30` switches the whole 64 kB.
The next instruction comes from the other page.
ticks writes the loaded image to both pages, so that instruction is present.
A later store goes to the selected page only.
`-output` reads the final page.

## Bank images

`-banks` loads `<name>_BANK_nn.bin` for the Rabbit, the ZX Next, and the MSX.
The Z180 and the RC2014 do not use those files.

## Tests

Run `make -C test/suites/ticks_page`.

The suite checks the Z180 map and `-b standard` with `-mz180`.
It checks the RC2014 ROM page and shadow RAM on the Z80 and the 8085.
It checks the ZX Next MMU.
The shell recipes do not run on Windows.
