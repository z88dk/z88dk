
; uint32_t _random_uniform_xor_32_(uint32_t seed)

SECTION code_stdlib

PUBLIC __random_uniform_xor_32_

__random_uniform_xor_32_:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   INCLUDE "stdlib/z80/random/asm_random_uniform_xor_32.asm"
