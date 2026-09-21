# ADR 0098 — frame-local word RMW keeps its address and value on the stack

Status: **Accepted**, default on for the measured targets. `local-rmw` opts out;
`gbz80-rmw` remains a compatibility alias.

## Context

`localbench/scratch` keeps its loop counter in BC, but the baseline repeatedly
spills the computed array address, old array word, and accumulator through
frame slots for each word read-modify-write. Each measured CPU emits a stable
pre-copt shape. The Z80-family, 8080 and VM1 shapes use HL/BC and frame slots;
Rabbit keeps the accumulator in IY; KC160 uses a stack-relative accumulator
slot. GBZ80 has its own stack-offset shape.

The 8085 prototype saved ticks but grew the full image by 3 bytes. It remains
out of scope.

## Decision

In `filter_dead_bc_parks`, match the exact pre-copt loop body for the current
CPU. For Z80, Z80N, Z180, eZ80 Z80-mode, 8080 and VM1, push the array pointer
and replacement word, update the accumulator through the existing stack home,
then pop and store the replacement. Rabbit pushes the array pointer, updates
the IY accumulator from the old word, computes the new word with BC, and stores
it through the saved pointer. KC160 pushes the pointer and accesses its
accumulator slot at the adjusted SP offset. GBZ80 retains its original
parameterized stack-offset rewrite.

The temporary pushes are balanced at the sequence boundary. The replacement
requires A and F dead after the matched body. The backward flag-liveness pass
proves F dead; the branch-aware A walk proves A dead. A failed shape, liveness
check or allocation leaves the original sequence in place. `local-rmw` is the
new shared opt-out; `gbz80-rmw` also disables it for compatibility. Both
`--opt-disable=...` and `IR_OFF=...` use the standard option registry.

## Regression coverage

`long_ir/localrmw.c` checks the array checksum on GBZ80, Z80, Z80N, Z180,
eZ80 Z80-mode, 8080, VM1, Rabbit 2000A/4000/6000 and KC160. GBZ80's three
assembly guards still check dead A/F, live A and live F; the legacy opt-out
alias has its own run. The Z80 target also runs with `local-rmw` disabled.

## Evidence

The full size scan compared 720 benchmark/CPU/frame cells. Fourteen cells
shrank by a total of **155 bytes**; no cell grew and no compile failed. Every
change was in localbench: the ten newly enabled CPUs' SP results, 8080 and VM1
FP (their output matches SP), and GBZ80 SP/FP.

The full tick comparison covered 720 benchmark/CPU/frame cells. The tick-scan
script now dispatches VM1 with `-clib=vm1` and `-mvm1`; its 60 VM1 cells were
measured with that path. All 720 runs reported `fail=0`; fourteen localbench cells were faster, none were slower, and
the aggregate fell by **81,382,400 ticks**. All other cells were unchanged.

Matched localbench A/B builds for the ten newly enabled CPUs:

| CPU | Full image bytes, off → on | Ticks, off → on |
| --- | ---: | ---: |
| Z80 | 4,633 → 4,621 (−12) | 325,264,693 → 318,506,293 (−6,758,400) |
| Z80N | 4,625 → 4,613 (−12) | 312,953,493 → 306,195,093 (−6,758,400) |
| Z180 | 4,606 → 4,594 (−12) | 305,370,222 → 299,315,822 (−6,054,400) |
| eZ80 Z80-mode | 4,471 → 4,461 (−10) | 68,939,500 → 68,094,700 (−844,800) |
| 8080 | 5,219 → 5,205 (−14) | 347,355,965 → 338,344,765 (−9,011,200) |
| VM1 | 5,161 → 5,150 (−11) | 339,663,545 → 332,623,545 (−7,040,000) |
| Rabbit 2000A | 3,843 → 3,839 (−4) | 130,059,117 → 127,947,117 (−2,112,000) |
| Rabbit 4000 | 3,982 → 3,977 (−5) | 134,347,086 → 131,953,486 (−2,393,600) |
| Rabbit 6000 | 3,974 → 3,969 (−5) | 130,756,686 → 128,363,086 (−2,393,600) |
| KC160 | 3,998 → 3,993 (−5) | 46,754,835 → 46,191,635 (−563,200) |

The 8085 feature-on image is byte-identical to feature-off at **4,719 bytes**;
its checksum passes. Its measured hand prototype was 3 bytes larger, so the
compiler does not select it.

The complete `long_ir` SP and FP builds passed. `examples/console/enigma.c`
printed `RXSEC` in both modes. The magnetic emulator behavior gate produced its
two expected “On The Path” hits in both modes.
