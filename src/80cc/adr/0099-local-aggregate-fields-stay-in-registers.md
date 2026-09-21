# ADR 0099 — promote fixed fields of non-escaping local aggregates

Status: **Accepted**, default on. aggregate-promote opts out.

## Context

localbench/record updates four fields of one local struct in a loop. 80cc
reconstructed each field address and moved each value through the frame on
every iteration. SDCC kept the fields as scalar values. The same source was
slower than SDCC on every CPU and frame mode measured.

## Decision

Before address folding, trace local struct addresses through unique IR_LEA
definitions and constant pointer copies/adds/subtracts. Replace exact scalar
loads and stores at fixed offsets with mutable vregs. The whole object must
remain private to the function.

Keep an object in memory if it is volatile, a parameter, named in debug mode,
address-escaped, dynamically indexed, accessed with an unsupported type or
width, or accessed through overlapping views. Arrays, aggregate copies, and
whole-object memory operations stay unchanged. Both --opt-disable=aggregate-promote
and IR_OFF=aggregate-promote restore the old path.

## Regression coverage

long_ir/aggpromote.c checks a loop-carried local struct, a field address passed
to a mutating callee, and overlapping union fields. The target runs in Z80 SP/FP,
8080, and GBZ80 modes. Existing aggregate_init, memberarr, structval, and
unionmem tests also pass with the optimization enabled.

## Evidence

The full corpus scans compared 720 compile-size and 720 tick cells across all
CPUs and available frame modes. Compile-only size fell by 2,098 bytes across
the corpus: 24 cells smaller, 696 unchanged, none larger. The tick scan had
24 faster cells, 696 unchanged, none slower, and no behavioral failures. Every
change was in localbench; adv_a and clisp had no section-size change.

localbench image-size and tick deltas, CPU by CPU:

| CPU | SP bytes | SP ticks | FP bytes | FP ticks |
| --- | ---: | ---: | ---: | ---: |
| Z80 | −149 | −29,629,600 | −53 | −15,593,600 |
| Z80N | −149 | −29,629,600 | −53 | −15,593,600 |
| Z180 | −149 | −28,485,600 | −53 | −12,390,400 |
| eZ80 Z80-mode | −93 | −3,884,800 | −36 | −1,009,600 |
| Rabbit 2000A | −31 | −4,512,000 | −47 | −6,116,000 |
| Rabbit 4000 | −21 | −3,590,400 | −37 | −5,200,000 |
| Rabbit 6000 | −21 | −3,590,400 | −41 | −5,312,000 |
| KC160 | −37 | −2,288,000 | −32 | −1,988,800 |
| 8080 | −149 | −31,125,600 | = SP | = SP |
| 8085 | −163 | −33,976,800 | = SP | = SP |
| GBZ80 | −98 | −29,708,800 | = SP | = SP |
| VM1 | −138 | −30,632,800 | = SP | = SP |
