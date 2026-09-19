# test/suites/matrix — tooling for BENCH_MATRIX.txt

The scripts that regenerate the columns of `../BENCH_MATRIX.txt` and the
measurements behind `src/80cc/HANDOVER_2026-08-31.md`. They exist so none of this
has to be re-derived.

All of them:

- find the repo from their own location, so they work from any cwd;
- put intermediates and results in `$WORK`, default
  `${TMPDIR:-/tmp}/z88dk-matrix`. **Set `WORK` to keep results** between runs;
- take a list of benchmark names as arguments (any directory under
  `test/suites/`), and emit one `|`-separated row per measurement.

They assume a built tree — `bin/` tools and `lib/clibs/` current. After a merge,
rebuild through the sub-makes, because `make bin/z88dk-z80asm` depends only on
`src/config.h` and will silently skip:

```sh
for d in z80asm sccz80 80cc zcc ticks copt ucpp zpragma; do
  make -C src/$d PREFIX=$(pwd) $( [ $d = z80asm ] && echo PREFIX_SHARE=$(pwd) ) install
done
make -C libsrc -j8 && make -C libsrc install
```

## The scripts

| script | what it produces |
|---|---|
| `allcpu.sh` | the **80cc-fp / 80cc-sp** columns, all 12 CPUs. Row: `bench\|cpu\|fp_size\|fp_ticks\|sp_size\|sp_ticks`, with `SAMESP` for the fp field on CPUs with no index register |
| `xcccpu.sh` | the **xcc -Os / xcc -Of** columns. Row: `bench\|cpu\|os_size\|os_ticks\|of_size\|of_ticks`. Edit `CPUS=` to pick CPUs — z180 and kc160 are in the list but will fail on benchmarks where xcc emits undocumented IY halves |
| `sizedec.sh` | section-level size decomposition, xcc vs 80cc. Row: `bench\|compiler\|section\|bytes`. This is what showed 93% of the size gap is `code_compiler` |
| `hotrun.sh` + `hotcmp.py` | cycle-accurate profiles. `hotrun.sh` leaves `$WORK/hot/<bench>.<cc>.hot` (count, T-states, disassembly per address); `hotcmp.py` aggregates them into per-category shares of the tick gap |
| `iso2.sh` | isolates xcc's optimisation levers with `-Cx-fno-…`, showing what inlining and the internal-ABI promotion are each worth |
| `sdcctrue.sh` | sdcc built twice — as shipped, and forced to the converter set 80cc derives — to measure how much the sdcc column is inflated by the missing format scan |
| `prof.py` | PC histogram from a `z88dk-ticks -trace` dump. Superseded by `hotrun.sh`; keep for the rare case where you want instruction counts rather than cycles |

## Typical uses

```sh
# regenerate the 80cc columns (~5 min, 360 cells)
WORK=~/matrix ./allcpu.sh charbench crcbench intbench ... md5 > 80cc.out

# where does the size gap live?
./sizedec.sh $(ls -d ../*bench ../sieve ../rle ../md5 | xargs -n1 basename)

# why is one benchmark slower? (cycle-weighted, not instruction counts)
./hotrun.sh interpbench && python3 ./hotcmp.py

# what is an xcc optimisation actually worth?
./iso2.sh hashbench queenbench fixedbench
```

## Things that will bite you

- **`z88dk-ticks` stops at 100 M cycles by default.** localbench, divbench and
  crcbench silently report exactly `100.00M`. These scripts pass
  `-counter 2000000000`; anything new must too.
- **Compare equal benchmark sets.** A compiler that fails one benchmark drops a
  row, and summing 29 against 30 produced a size gap twice the real one. Intersect
  before you total.
- **Geometric mean and total cycles disagree** when one benchmark dominates —
  divbench alone (80cc 3.33× faster) flipped the sign of the overall verdict.
  Quote both, or say which and why.
- **fp mode is `-fframe-pointer`.** `-Cc-frameix` no longer reaches 80cc since
  the multi-compiler options moved off `-compiler` (#3089), and it fails silently
  with no binary rather than erroring.
- **xcc options go through `-Cx`**, including `-Cx-Os` — zcc hardcodes `-Of` for
  xcc and has no other pass-through.

## Per-CPU flags

```
z80   (default)      -b msx          z80n   -clib=z80n      -mz80n
z180  -clib=z180     -mz180          ez80   -clib=ez80_z80  -mez80_z80
r2ka  -clib=rabbit   -mr2ka          r4k    -clib=rabbit4k  -mr4k
r6k   -clib=rabbit6k -mr6k           kc160  -clib=kc160     -mkc160
8080  -clib=8080     -m8080          8085   -clib=8085      -m8085
gbz80 -clib=gbz80    -mgbz80         vm1    -clib=vm1       -mvm1
```

8080, 8085, gbz80 and vm1 have no index register, so fp == sp and only sp is
measured.

## Maintaining the committed snapshot

`../BENCH_MATRIX.txt` is the current committed snapshot. Keep exactly one
complete matrix table there; do not append prior reports or old snapshots.

To update it:

1. Append the outgoing committed table and its measurement notes to the local
   `../BENCH_MATRIX.history.txt` archive before regenerating the table.
2. Regenerate a complete table using the matrix scripts and generator above.
3. Replace `../BENCH_MATRIX.txt` with the newest table only.
4. Commit `../BENCH_MATRIX.txt`; keep `../BENCH_MATRIX.history.txt` untracked.

Git history also retains earlier committed versions of the table. The local
archive preserves the prior appended reports and notes without growing the
committed snapshot.
