
; uint16_t _random_uniform_cmwc_8_(void *seed)

SECTION code_stdlib

PUBLIC _random_uniform_cmwc_8_

_random_uniform_cmwc_8_:

   call asm_random_uniform_cmwc_8
   
   ld l,a
   ld h,0
   
   ret

   INCLUDE "stdlib/z80/random/asm_random_uniform_cmwc_8.asm"
