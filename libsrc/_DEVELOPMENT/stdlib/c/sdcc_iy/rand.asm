
; int rand(void)

SECTION seg_code_stdlib

PUBLIC _rand

_rand:

   INCLUDE "stdlib/z80/asm_rand.asm"
