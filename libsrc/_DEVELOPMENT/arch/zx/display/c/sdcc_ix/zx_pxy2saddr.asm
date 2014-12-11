
; void *zx_pxy2saddr(uchar x, uchar y)

SECTION code_arch

PUBLIC _zx_pxy2saddr

_zx_pxy2saddr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld h,e
   
   INCLUDE "arch/zx/display/z80/asm_zx_pxy2saddr.asm"
