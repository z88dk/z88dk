# ADR 0095 — Variable byte shifts use the byte loop where it pays

Status: **Accepted**, default on for z80, z180, ez80_z80, gbz80, and kc160.

## Context

unsigned char and signed char shift operands are promoted to int. When the
result is cast back to a byte, 80cc still selected the two-byte variable-shift
loop. A byte loop can avoid shifting the discarded high byte, but the proof is
different for left and right shifts:

* The low byte of a left shift depends only on the source's low byte.
* A right shift pulls bits down from the high byte. It is safe to narrow only
  when the source is known to be zero-extended from a byte (logical) or
  sign-extended from a byte (arithmetic).

## Decision

Narrow variable-count IR_SHL results to one byte on the selected CPUs. Narrow
variable-count IR_SHR only when the source proof above succeeds, and narrow
the source only when that shift is its byte-width consumer. Counts that are
materialized as literal IR_LD_IMM vregs stay on the existing path: compound
bitfield shifts use that representation, and narrowing it regressed their
read-modify-write lowering.

The byte loop uses A for the value. When BC is live and DE is free, E holds the
count, avoiding a BC save/restore; otherwise B is used with the existing BC
preservation and byte-home checks. AF is saved only to protect an A-cached value
from the count load or a B-home source before B becomes the counter. This reduces
both stack traffic and register pressure versus the first measured version.

The var-byte-shift opt-out restores the established lowering. 8080/8085
retain the word/helper path because they lack the required accumulator CB
shifts. z80n and Rabbit also retain it: their shiftbench tick rows regressed
with the byte loop (z80n by 1.3%; Rabbit by up to 1.0% in the measured rows).
The other enabled CPUs had no slower shiftbench cell.

## Regression coverage

test/suites/long_ir/byteshr.c covers variable left shift, zero-extended
logical right shift, sign-extended arithmetic right shift, and a wide-source
logical right-shift control. The control includes sources such as 0x0100,
whose high byte must not be discarded. The count table includes zero and counts
that remain defined for the promoted 16-bit operand.

The materialized-literal exclusion is covered by the existing bitfield
compound-assignment test; narrowing its literal count caused the DE park in the
read-modify-write sequence to be stranded.

## Measurements

The 720-cell compile-only corpus scan (both frame modes, 12 CPUs) changed only
shiftbench: −65 bytes total, 10 cells smaller, 0 larger, and 0 build
failures. On z80, z180, ez80_z80, gbz80, and kc160, both frame modes are smaller.
All other cells are unchanged.

The shiftbench tick scan covered 18 CPU/frame cells: 10 were faster and 8
were unchanged; none were slower. Changes on enabled CPUs:

| CPU | SP | FP |
| --- | ---: | ---: |
| z80 | −1.91% | −1.02% |
| z180 | −1.95% | −1.19% |
| ez80_z80 | −1.42% | −1.12% |
| gbz80 | −1.91% | −1.91% |
| kc160 | −0.82% | −0.70% |

long_ir completed 858/858 tests in each frame mode with 0 test failures. The
suite's only build error was its pre-existing missing mbf32_vm1.lib for
longshl_vm1.bin. IR_CLOB_VERIFY remained at 0 stale-cache sites and
IR_PARK_VERIFY remained parks=6 steal=0 depth_mismatch=0 with the feature
enabled.

## Consequences

The CPU boundary is deliberate, not an ISA capability test. z80n and Rabbit
support byte shifts, but the measured loop is slower there. Reconsider those
targets only with a lowering that removes the measured tick regression.
