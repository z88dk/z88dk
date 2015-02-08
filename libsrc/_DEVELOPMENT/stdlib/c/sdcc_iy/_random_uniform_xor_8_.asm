
; uint16_t _random_uniform_xor_8_(uint32_t seed)

SECTION code_stdlib

PUBLIC __random_uniform_xor_8_

__random_uniform_xor_8_:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   call asm_random_uniform_xor_8
   
   ld l,a
   ld h,0
   
   ret

   INCLUDE "stdlib/z80/random/asm_random_uniform_xor_8.asm"
