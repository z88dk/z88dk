
; void *zx_saddrpleft(void *saddr, uchar bitmask)

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
