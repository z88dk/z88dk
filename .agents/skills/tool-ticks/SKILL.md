---
name: tool-ticks
description: >
  z88dk-ticks cycle-accurate emulator: TIMER bounds, hotspots, debugger, CPU -m flags. Use for suite runs and library timing.
---

# Tool — ticks

| | |
|--|--|
| Binary | `z88dk-ticks` |
| Help | Run bare `z88dk-ticks` (NOT -h — treated as a filename) |
| Wiki (local draft) | `wiki/tools/Tool---ticks.md` |


## Agent essentials

| Rule | Detail |
|------|--------|
| CPU flag **before** binary | `z88dk-ticks -m8085 prog.bin` |
| TIMER | `-x map -start TIMER_START -end TIMER_STOP -counter …` |
| Default `-counter` | **100000000**. Whole-program `+test` PRINTF of n-body n≥~125 dies mid-loop; the `10000000x` line is the cap, not `%f`. Raise `-counter`. |
| Hotspots | debugger `hotspot on` → file `hotspots` in cwd |
| Models | `-m8080 -m8085 -mz80 -mz80n -mz180 -mgbz80 …` |

Full A/B and bench recipes: `methodology-measure`.


## Condensed reference (from wiki / tree)

# Tool — ticks (`z88dk-ticks`)

Ticks is a command-line CPU emulator used to **run** small binaries and **count T-states**. Prefer it over wall-clock timing for library and benchmark work. It includes a debugger, hotspot histogram, and optional function profiler.

## Quick start

```text
zcc +test -vn prog.c -o prog.bin -m
z88dk-ticks -mz80 prog.bin
```

8085 binary (must match the CPU model):

```text
zcc +test -clib=8085 -vn prog.c -o prog.bin -m -lndos
z88dk-ticks -m8085 prog.bin
```

## Help path (important)

Do **not** use `z88dk-ticks -h`. The tool treats `-h` as an input file name and fails.

Run **`z88dk-ticks`** with no arguments to print usage.

## Capability summary

| Area | Live options (this tree) |
|------|---------------------------|
| CPUs | `-m8080`, `-m8085`, `-mgbz80`, `-mz80`, `-mz80_strict`, `-mz180`, `-mz80n`, `-mez80_z80`, `-mr800`, `-mkc160`, `-mkc160_z80`, Rabbit `-mr2ka` … `-mr6k` |
| Control | `-pc`, `-start`, `-end`, `-counter`, `-w`, `-trace`, `-d` / `-debug` debugger |
| Memory | `-l` load address, `-b` model, `-rom`, `-output` dump |
| Symbols | `-x` map/symbol file (use **before** `-start`/`-end` when symbols name those addresses) |
| I/O | `-iochar`, `-ide0`, `-ide1` |

Wrong CPU model → wrong illegal-opcode behaviour and wrong timings. Always match `-m…` to the binary.

### Corrected names (old wiki was wrong)

| Old wiki text | Live tool |
|---------------|-----------|
| `-gbz80` | **`-mgbz80`** |
| `-mz80-zxn` | **`-mz80n`** |
| `-mr2k` | **`-mr2ka`** |

---

… (full reference: in-tree wiki page and live tool help)


## Related

- Driver front end: `tool-zcc`
- Measurement: `methodology-measure`, `tool-ticks`
