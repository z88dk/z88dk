
; void *zx_saddrpleft(void *saddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddrpleft

EXTERN asm_zx_saddrpleft

_zx_saddrpleft:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_zx_saddrpleft
