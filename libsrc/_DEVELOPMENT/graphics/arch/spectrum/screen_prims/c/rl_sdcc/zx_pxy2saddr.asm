
; void *zx_pxy2saddr(uchar x, uchar y)

XDEF zx_pxy2saddr

zx_pxy2saddr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld h,e
   
   INCLUDE "../../z80/asm_zx_pxy2saddr.asm"
