# 80cc Game Boy register-copy flow — 2026-09-17

This records the `regcopy-flow` measurement for ADR 0086. It uses
`src/80cc/scripts/corpus_sizescan.sh` (30 benchmarks, 12 CPUs, two frame
modes) with `IR_OFF=regcopy-flow` as the baseline. It is a `code_compiler`
section scan, not a full binary matrix regeneration.

## Census

The final assembly before the change contained 660 `ex de,hl` instructions in
the Z80 frame-mode corpus, 373 of them in `md5`. The Game Boy corpus had 125
`ex de,hl`, 645 `ld de,hl`, and 270 `ld hl,de`. These are raw counts, not
estimates of recoverable bytes. Z80's common
`ex de,hl; adc hl,bc; ex de,hl` belongs to the 32-bit carry path.

The selected Game Boy shape is a dead `ld hl,de` after a slot store. Only BC
changes before an unconditional local jump, and the jump target reloads HL
before reading it. The `long_ir/regcopyflow.c` assembly diff deletes exactly
that line.

## Results

| Measure | Result |
|---|---:|
| Size cells | 720 on and 720 off; no missing cells |
| Total `code_compiler` bytes | −232 |
| Size cells smaller / larger | 46 / 0 |
| Non-Game Boy cells changed | 0 of 660 |
| Game Boy bytes per frame mode | −116 |
| Game Boy tick cells faster / slower | 46 / 0 of 60 |
| Game Boy aggregate ticks | −6,508,688 (−0.2271%) |
| Benchmark failures | 0 |

Twenty-three of 30 benchmarks shrink in both Game Boy frame modes.
`ptrbench` and `hashbench` save 12 bytes per mode; `searchbench`,
`switchbench`, `maskbench`, and `md5` save 8 each. The other 17 affected
benchmarks save 2–6 bytes per mode. The largest tick changes are `ptrbench`
−2.4550%, `intbench` −1.5450%, and `searchbench` −1.1547%.

## Validation

- Existing `long_ir`: 823/823 passed in each frame mode. The only build error
  was the known `longshl_vm1` missing-assembler case.
- New `regcopyflow` targets: 4/4 passed (Z80 sp/fp, Game Boy on/opt-out).
- Console gates: `enigma` printed `RXSEC` in both frame modes; `clisp`
  printed 6 then 42 in both.
- Gate-off assembly matched the saved pre-change compiler output for all 30
  Game Boy corpus sources after filtering timestamp, `MODULE`, and `C_LINE 0`.
- `check_options.sh`, `check_ownership.sh`, and `git diff --check` passed.

The next task is to classify the remaining Game Boy `ld hl,de` readers before
proposing a broader liveness rule; see `src/80cc/DESIGN_INDEX.md`.
