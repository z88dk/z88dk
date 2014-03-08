
; void *zx_pxy2saddr(uchar x, uchar y)

XDEF zx_pxy2saddr

zx_pxy2saddr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld h,e
   
   INCLUDE "../../z80/asm_zx_pxy2saddr.asm"
