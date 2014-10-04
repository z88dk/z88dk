
; void *zx_cy2aaddr(uchar row)

SECTION seg_code_arch

PUBLIC _zx_cy2aaddr

_zx_cy2aaddr:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_cy2aaddr.asm"
