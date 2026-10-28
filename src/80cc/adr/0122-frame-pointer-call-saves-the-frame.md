# ADR 0122 — A frame-pointer call saves the frame register

Status: **Accepted**. A correctness fix, so it is **not gated**.

ADR 0121 is the signed-constant record on branch `80cc-constfold` (#3204).
This record is 0122 so the two files keep distinct numbers.

## Context

Issue #3209. With `-fframe-pointer`, 80cc keeps the frame in `frame_reg()`
(IX on the product path). The epilogue of a function that keeps a frame is
`ld sp,<frame>`, then `pop <frame>`, then `ret`. A callee that changes that
register makes `ret` leave at the wrong address.

Newlib objects from sccz80 do change IX. `sprintf`, `qsort`, and the
`FILE*` routines are the calls that stopped the frame-pointer stdcbench.
sccz80 does not address locals through IX. 80cc stack mode does not either.
Both compilers link the same prebuilt `lib/clibs/sccz80/z80.lib`. The save
belongs in the 80cc caller.

## Decision

A function that keeps a frame saves `frame_reg()` around each `IR_CALL`.
The push sits under the arguments. The pop runs after argument cleanup and
before the result store.

The gate is `call_saves_frame`: `fp_active` and the function is not
frameless. That is the same gate as the epilogue. Stack mode leaves the
register alone. A frameless function leaves it alone. `frame_reg()` supplies
the name. 8080, 8085, gbz80, and vm1 force the frame pointer off, so this
path emits no `ld ix` there.

Push order runs from the caller toward the callee. Saved BC comes first
when the call saves BC. The frame word follows, then the arguments, then
the return address.

Two call shapes:

- No pre-pushed arguments. `gen_call` pushes the frame and pops it. The
  word stays out of `cur_sp_adjust`. The word is part of the slot
  adjustment, so a stack read does not treat the saved frame as a local.
- Pre-pushed arguments. The opening `IR_PUSH_*` pushes the frame.
  `cur_sp_adjust` grows by 2. `fp_restore_pre_frame` pops that word. A
  nested call pops its own word. `ir_build` marks the first push.
  `IR_PUSH_ARG` uses `imm == 1`. `IR_PUSH_STRUCT` keeps the byte count
  in the low bits and sets `IR_PUSH_STRUCT_OPENS` (bit 62).

A fastcall with no stacked arguments still saves inside `gen_call`. The
frame word stays out of `pushed_bytes`. A `__smallc` variadic call still
emits `ld a,n` for the argument words only. A `__z88dk_callee` call pops
the frame in the caller and leaves the arguments for the callee. `pop ix`
and `pop iy` leave HL, DE, A, and the flags unchanged.

An indirect fastcall or `__sdcccall(1)` call loads the function pointer
into the spare index register. In frame-pointer mode that spare is IY, and
the dispatch is `l_jpiy`. The frame push uses the frame register. A plain
indirect call uses `l_jphl`.

The save is not a liveness choice. Every framed call pays the push and the
pop. A callee that already preserves the register pays it too. A filter on
callees in the same file is unsound. A frameless callee can change IX by
calling out. A missed save returns to the wrong address.

The frame pushes cannot merge across calls. Each call loads its arguments
from the frame, then stores the result back.

Nested saves stop at depth 8. A deeper nest prints
`ir_lower: frame-pointer save nested too deep` and the lowerer returns -1.

## Scope

The save covers `IR_CALL` from a function that keeps a frame.

- Helpers stay on the ADR 0005 whitelist. An `HCALL` is not wrapped. A
  helper off that list that changes IX can still break a frame.
- Stack mode keeps the callee-saved rule for IX. IX may hold an idx2 home
  there. `func_call_clobbers` stays empty. A clobber bit would only stop
  that home. It would not reload a frame.
- The sccz80 library stays as sccz80 built it. No library `#ifdef`. No
  stdio wrapper.
- A frameless 80cc function does not save for its own caller. A caller
  that keeps a frame saves around that call.

## Consequences

- A callee that changes IX no longer breaks `ld sp,ix` in a caller that
  keeps a frame.
- The classic stdcbench frame total moved from 7.2 to 7.0. Each framed
  call grew by one push and one pop. That cost is accepted.
- There is no `--opt-disable` name. An opt-out would restore the miscompile.
- The default flip in ADR 0012 stays a separate decision. This record
  does not set `c_framepointer_is_ix`.
- The regression test is `test/suites/long_ir/fpsave.c`, target
  `fpsave_fp.bin` (Z80, `-fframe-pointer`). The callees are `__naked` and
  set IX to 0. They do not write IY. Covered shapes:
  - a direct call, a function pointer, and a pointer reloaded from the
    frame after an earlier clobber
  - an array of pointers, and a pointer passed into another function
  - nested calls, and a struct argument with a nested leaf
  - `__z88dk_fastcall` direct and through a pointer, and `__z88dk_callee`
  - a zero-argument call, a variadic word count, and a long return in DEHL
- Stack mode is not a target. A stack-mode caller is not required to
  survive an IX clobber.

See ADR 0005, ADR 0011, and ADR 0012.
