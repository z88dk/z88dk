
; uint16_t _random_uniform_cmwc_8__fastcall(void *seed)

SECTION code_clib
SECTION code_stdlib

PUBLIC __random_uniform_cmwc_8__fastcall

EXTERN asm_random_uniform_cmwc_8

__random_uniform_cmwc_8__fastcall:

   call asm_random_uniform_cmwc_8
   
   ld l,a
   ld h,0
   
   ret
