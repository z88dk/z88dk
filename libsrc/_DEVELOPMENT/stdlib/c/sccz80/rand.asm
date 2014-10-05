
; int rand(void)

SECTION seg_code_stdlib

PUBLIC rand

rand:

   INCLUDE "stdlib/z80/asm_rand.asm"
