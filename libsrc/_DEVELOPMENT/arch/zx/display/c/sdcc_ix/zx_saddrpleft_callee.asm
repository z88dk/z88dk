
; void *zx_saddrpleft_callee(void *saddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddrpleft_callee

EXTERN asm_zx_saddrpleft

_zx_saddrpleft_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_zx_saddrpleft
