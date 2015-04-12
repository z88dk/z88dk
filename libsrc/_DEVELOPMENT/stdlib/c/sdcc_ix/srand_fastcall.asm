
; void srand_callee(unsigned int seed)

SECTION code_stdlib

PUBLIC _srand_callee

_srand_callee:

   INCLUDE "stdlib/z80/asm_srand.asm"
