
; void *zx_saddrpleft(void *saddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddrpleft

EXTERN asm_zx_saddrpleft

zx_saddrpleft:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_zx_saddrpleft
