# Rabbit memory model, banking and far pointers

The Rabbit processors have a 64K logical address space and a bigger physical
address space. A memory management unit (MMU) maps one to the other. This page
describes the MMU, the way z88dk uses it for code banks and far pointers, and
the way `z88dk-ticks` models it.

z88dk support:

| Tool | State |
|---|---|
| `z88dk-ticks` `-mr2ka`, `-mr3k` | segments, `XPC`, `ldp`, `lcall`, `ljp`, `lret` |
| `z88dk-ticks` `-mr4k`, `-mr6k` | the same, 12-bit `LXPC`, `llcall`, `llret`, `lljp`, `ldf`, 12-bit segment offsets |
| `z88dk-ticks` debugger | `bank:address` breakpoints, `reg`, `x` and `dis` on banked addresses |
| `+test` and `+z80` start-up code | `crt_init_rabbit.inc` (MMU set-up), `crt_rabbit_banks.inc` (code banks) |
| `+rcmx000` start-up code | `crt_rabbit_banks.inc` only. `rcmx000_boot.asm` sets the MMU for the board. |
| `sccz80` and `80cc` | `#pragma bank`, `__banked`, `__far` |
| classic C library | `banked_call`, `__far_page`, `l_far_mapaddr` and the `lp_*` routines in `r2ka_crt0.lib` and `r4k_crt0.lib` |

## The hardware

### Segments

The logical space has four segments. Each segment has a start address, and
the segments follow each other in this order:

| Segment | Logical addresses | Physical address |
|---|---|---|
| root | `0` up to the data segment | the same as the logical address |
| data | `SEGSIZE[3:0]` × 0x1000 up to the stack segment | logical address + `DATASEG` × 0x1000 |
| stack | `SEGSIZE[7:4]` × 0x1000 up to 0xE000 | logical address + `STACKSEG` × 0x1000 |
| extended (XMEM) | 0xE000 to 0xFFFF | logical address + `XPC` × 0x1000 |

The processor sets `SEGSIZE` to 0xFF at reset. Then the data and stack
segments are empty, and the root segment covers everything up to 0xE000.

The offsets have a granularity of 4K. The extended segment is 8K long, so
the windows for `XPC` = n and `XPC` = n + 1 overlap by 4K.

### Registers

All registers are in the internal I/O space. Use the `ioi` prefix to reach
them.

| Register | Address | Rabbit 2000/3000 | Rabbit 4000 and later |
|---|---|---|---|
| `MMIDR` | 0x10 | MMU instruction/data register | the same |
| `STACKSEG` | 0x11 | 8-bit offset | 8-bit alias of `STKSEGL`. A write clears `STKSEGH`. |
| `DATASEG` | 0x12 | 8-bit offset | 8-bit alias of `DATSEGL`. A write clears `DATSEGH`. |
| `SEGSIZE` | 0x13 | segment boundaries | the same |
| `MB0CR` to `MB3CR` | 0x14 to 0x17 | memory bank control | the same |
| `STKSEGL`, `STKSEGH` | 0x1A, 0x1B | not present | 12-bit stack offset (`STKSEGH` has 4 bits) |
| `DATSEGL`, `DATSEGH` | 0x1E, 0x1F | not present | 12-bit data offset (`DATSEGH` has 4 bits) |
| `EDMR` | 0x420 | not present | write 0xC0 to switch on the Rabbit 4000 instruction set |

The Rabbit 2000 and 3000 have 20-bit physical addresses (1MB). The Rabbit 4000
and later have 24-bit physical addresses (16MB).

### XPC and LXPC

`XPC` has 8 bits. The `LXPC` of the Rabbit 4000 and later has 12 bits and
uses the same window. Instructions:

| Instruction | Action |
|---|---|
| `ld xpc,a`, `ld a,xpc` | read and write `XPC`. A write clears the upper `LXPC` bits. |
| `ld lxpc,hl`, `ld hl,lxpc` | read and write `LXPC`. The top 4 bits of `HL` are ignored. |
| `lcall x,mn` | push `XPC`, push the return address, set `XPC` to `x`, jump to `mn` |
| `ljp x,mn` | set `XPC` to `x`, jump to `mn` |
| `lret` | pop the return address, pop `XPC` |
| `llcall lxpc,mn`, `llcall (jkhl)` | the same as `lcall`, with a 12-bit `LXPC` pushed as two bytes |
| `llret`, `lljp` | the same as `lret` and `ljp`, with a 12-bit `LXPC` |
| `ldp` | load or store 16 bits at a physical address. The address bits 19:16 come from `A[3:0]`. |
| `ldf` | Rabbit 4000 and later. Load or store at a 24-bit physical address. |

Do not mix `lcall` and `llcall` in one program. The manual warns that
`lcall` clears the upper bits of `LXPC`.

The PC has 16 bits. If the PC passes 0xFFFF, it wraps to 0x0000 in the root
segment. It does not continue in the next page. Code in a bank must end
before 0xFFFF.

## The z88dk bank model

z88dk uses an 8K bank. The bank is seen at 0xE000 to 0xFFFF with
`XPC` = bank × 2. An even `XPC` makes the window start on an 8K boundary,
so the banks do not overlap.

| Item | Value |
|---|---|
| bank N, `XPC` | N × 2 |
| bank N, physical address | N × 0x2000 + 0xE000 |
| bank 0 | the 64K root image. Banked code uses banks 1 and up. |
| address of a banked symbol in a map file | `N << 16` + the address in the window, for example `$1E000` |

The first bank is at physical 0x10000, directly after the 64K root image.
A flash image is the root image followed by the banks.

The window is also the top of the near address space. Make sure that the
stack and all data are below 0xE000, or they move when `XPC` changes. A
program that uses banks or far pointers therefore has 56K of near space.

### Start-up code

`lib/crt/classic/crt_init_rabbit.inc` runs before the stack set-up.
`+test` and `+z80` include it. It writes only the registers for which you
define a pragma.

| Pragma | Register |
|---|---|
| `CRT_RABBIT_DATASEG` | `DATASEG`. On Rabbit 4000 and later, a 12-bit value goes to `DATSEGL` and `DATSEGH`. |
| `CRT_RABBIT_STACKSEG` | `STACKSEG`. On Rabbit 4000 and later, a 12-bit value goes to `STKSEGL` and `STKSEGH`. |
| `CRT_RABBIT_SEGSIZE` | `SEGSIZE`. Written last. |
| `CRT_RABBIT_MB0CR` to `CRT_RABBIT_MB3CR` | memory bank control |
| `CRT_RABBIT_XPC` | the first `XPC` value |

On the Rabbit 4000 and later the file also writes 0xC0 to `EDMR`.

`lib/crt/classic/crt_rabbit_banks.inc` defines the bank sections `BANK_01`
to `BANK_78` (hexadecimal, 120 banks). It does nothing unless you define
`CRT_RABBIT_BANKS`, the number of banks. Define `CRT_ORG_BANK_nn` to change
the origin of a bank. The default is 0xE000. If banks are on, `+test` puts the
stack at 0xE000 and not at 0xFF00.

### Banked code

Put `#pragma bank N` in a source file. Mark each function that other banks
call with `__banked`.

```c
/* bank1.c */
#pragma bank 1
int bank1_inc(int x) __banked { return x + 1; }

/* main.c */
extern int bank1_inc(int x) __banked;
int main(void) { return bank1_inc(41); }
```

```
zcc +test -clib=rabbit -pragma-define:CRT_RABBIT_BANKS=1 main.c bank1.c -o app.bin -m
z88dk-ticks -mr2ka -banks app.bin
```

Use `-clib=rabbit4k` or `-clib=rabbit6k` for the Rabbit 4000 and 6000.
Both `sccz80` and `80cc` generate the call as `call banked_call` followed by
a 4-byte `defq` of the target.

`banked_call` (in `r2ka_crt0.lib` and `r4k_crt0.lib`) does these steps:

1. It saves the old `XPC` and the real return address on a separate stack.
2. It loads `XPC` with the bank × 2.
3. It calls the function.
4. It restores `XPC` and returns.

The separate stack has `CLIB_BANKING_STACK_SIZE` bytes (100 by default).
The function sees a normal near-call frame.

`banked_call` saves and restores only the low 8 bits of `XPC`. A banked call
from code that runs with an `LXPC` above 255 loses the high bits.

Data can also be banked. Declare it with `__banked`, and put it in a bank
with `#pragma bank`. The compiler uses `l_far_mapaddr` and the far routines.

### Far pointers

A `__far` pointer holds a 24-bit physical address. The `lp_*` routines map
the page that holds the address into the window, make the access, and
restore the old mapping. `__far_start`, `__far_end` and `__far_page` do the
mapping.

| Processors | Reach | Mapping |
|---|---|---|
| Rabbit 2000, 3000 | the first 1MB | 8-bit `XPC` |
| Rabbit 4000 and later | all 16MB | 12-bit `LXPC` |

For far pointers without code banks, define `CRT_RABBIT_BANKS=0`. This
moves the stack below the window.

The Rabbit 4000 version keeps the old `LXPC` in a static word. A far access
is therefore not reentrant. Do not use far pointers in an interrupt routine
if the main program uses them.

## z88dk-ticks

`z88dk-ticks` models the segment map, `XPC`, `LXPC`, the registers in the
table above, and the instructions in the first table. All Rabbit programs
use this model. If a program does not change the MMU registers or `XPC`, the
map is the same as a flat 64K space. The test binaries in
`test/suites/long_ir` run with the same output and tick counts as before.

| Item | State |
|---|---|
| physical memory | 1MB (Rabbit 2000, 3000) or 16MB (Rabbit 4000 and later) |
| instruction fetch and data access | go through the segment map |
| `ldp`, `ldf` | physical addresses. A 32-bit pointer `0xFFFF:addr` is a logical address. |
| `MBxCR`, wait states, write protection | not modelled. Tick counts do not change. |
| `ipset`, `ipres` | the priority register is tracked. It does not mask interrupts. |
| system and user mode | not modelled |
| Rabbit 5000 | `z88dk-ticks` treats it as a Rabbit 4000 |

To run a program with banks, add `-banks`:

```
z88dk-ticks -mr2ka -banks app.bin
```

`-banks` loads `<name>_BANK_nn.bin` (the files that `z80asm` writes next to
the program) at physical 0x10000 + (nn - 1) × 0x2000. Each bank has 8K.

### Debugger

Start the debugger with `-d`. Load the map file with `-x` so that names work.

| Command | Action |
|---|---|
| `break _func1` | break on a banked symbol. It hits only if the bank is mapped. |
| `break 1:0xE000` | break on `bank:address` |
| `reg` | also shows `xpc`, `segsize`, `dataseg` and `stackseg` |
| `x /4 1:0xE000`, `dis 0x1E000 3` | show the memory of a bank, even if it is not mapped |

Each part of `bank:address` is a number. A number is decimal, or
hexadecimal with a `$` or `0x` prefix. A hit message prints the address in
the same style, for example `Hit breakpoint 1: @$1:$E000 (_bank1_inc)`.

The ZXN and MSX memory models of `z88dk-ticks` use the same notation. On the
ZXN, the bank is the first of the two 8K pages in MMU slots 6 and 7, as in
`zxn_banked_call.asm`. This was not tested with a real ZXN build. On the
MSX, the bank is the 16K page at 0x8000, and pages 0 to 3 hold the 64K image.

## Known limits

* The stack and data must be below 0xE000 if you use banks or far pointers.
* `banked_call` keeps only the low 8 bits of `XPC`.
* An interrupt routine must save and restore `XPC` itself if it uses the
  window.
* The `+z80` target with a Rabbit library does not link with the default
  exit method, because that method uses `halt`. Use
  `-pragma-define:CRT_ON_EXIT=0x10002`.
* `__far` function pointers (`l_farcall`) have no Rabbit implementation.
* The far string functions (`strcmpf` and others) are not in the Rabbit
  libraries.
* Watchpoints and source-line breakpoints in banked code do not know about
  banks.

## Tests

The suite in `test/suites/rabbit_mmu` covers the segment map, the Rabbit
4000 registers, the start-up code, banked calls and data, far pointers (also
above 1MB), and the debugger. It also has tests for the ZXN and MSX bank
notation. Run it with `make -C test/suites/rabbit_mmu`.

## Sources

* Rabbit Family of Microprocessors, Instruction Reference Manual.
* [Rabbit 4000 Microprocessor User's Manual](https://datasheets.chipdb.org/Rabbit/4000/R4000UM.pdf),
  chapter 5 and the register descriptions.
* `lib/target/rcmx000/classic/rcmx000_boot.asm` for the Rabbit 2000
  register addresses.
