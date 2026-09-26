; LLVM-Z80 lowers non-inlineable llvm.memset intrinsics to this helper.
; Its register ABI already matches z88dk's overlap-safe asm_memset core:
; dest=HL, byte value=E, and count=BC.  The compiler ignores the core's
; HL/DE/BC return state because the intrinsic returns void.

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l_clang

PUBLIC ___z80_memset_builtin

EXTERN asm_memset

___z80_memset_builtin:
   jp asm_memset
