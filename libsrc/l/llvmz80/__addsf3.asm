; compiler-rt-named 32-bit float arithmetic helpers for ravn/llvm-z80 clang,
; bridged to z88dk's math32 (IEEE-754 binary32) cores.  ravn/llvm-z80 #277.
;
; With double==float==binary32 (clang/lib/Basic/Targets/Z80.cpp), clang lowers
; float/double arithmetic to the 32-bit sf libcalls __addsf3/__subsf3/
; __mulsf3/__divsf3.
;
; ABI (ravn/llvm-z80, since the Z80LegalizerInfo.cpp change tracked by #277):
; these four libcalls are emitted with CallingConv::Z80_SDCCCall0 (clang's
; sdcccall(0)) rather than the general C ABI, WHEN the compiler is invoked
; with `-mllvm -z80-float-sdcccall0` -- see
; llvm/test/CodeGen/Z80/issue-277-f32-libcall-sdcccall0.ll.  The flag is
; opt-in (default OFF) because the ELF/standalone `--target=z80` path has its
; OWN compiler-rt float runtime, written for the default C ABI; z88dk's zcc
; must pass this flag for `-compiler=llvmz80` builds, or this bridge will
; link fine but silently compute garbage (every operand read from the wrong
; place).  sdcccall(0) pushes BOTH 32-bit operands on the stack, in declared
; order (so the second-declared operand is on top, closest to the return
; address), and returns the 32-bit result in DE:HL (D=MSB).
;
; z88dk math32 already ships wrappers for exactly this convention --
; libsrc/math/float/math32/c/sdcc/cm32_sdcc_fsadd.asm (+ fssub/fsmul/fsdiv) --
; written for SDCC's own __sdcccall(0)/__smallc stack-arg convention with the
; identical push order and DE:HL(D=MSB) result. So the bridge is a PURE ALIAS:
; no register shuffling, no operand-order glue, just a tail JP. This was
; verified end-to-end at runtime under ntvcm (order-sensitive sub/div cases
; included) -- see z88dk/test/clang/runtime_float.c + runtime_float.sh.
;
; (This supersedes an earlier prototype of this file that word-swapped
; operands/result to bridge the *old* CallingConv::C ABI -- that swap-shim is
; no longer needed once the compiler emits sdcccall(0) for these libcalls.)

SECTION code_l_clang

PUBLIC ___addsf3
PUBLIC ___subsf3
PUBLIC ___mulsf3
PUBLIC ___divsf3

EXTERN cm32_sdcc_fsadd
EXTERN cm32_sdcc_fssub
EXTERN cm32_sdcc_fsmul
EXTERN cm32_sdcc_fsdiv

___addsf3: jp cm32_sdcc_fsadd
___subsf3: jp cm32_sdcc_fssub
___mulsf3: jp cm32_sdcc_fsmul
___divsf3: jp cm32_sdcc_fsdiv
