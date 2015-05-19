
; uint16_t _random_uniform_cmwc_8__fastcall(void *seed)

SECTION code_stdlib

PUBLIC __random_uniform_cmwc_8__fastcall

__random_uniform_cmwc_8__fastcall:

   call asm_random_uniform_cmwc_8
   
   ld l,a
   ld h,0
   
   ret

   INCLUDE "stdlib/z80/random/asm_random_uniform_cmwc_8.asm"
