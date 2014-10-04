
; void *zx_cyx2aaddr(uchar row, uchar col)

SECTION seg_code_arch

PUBLIC _zx_cyx2aaddr

_zx_cyx2aaddr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld h,e
   
   INCLUDE "arch/zx/display/z80/asm_zx_cyx2aaddr.asm"
