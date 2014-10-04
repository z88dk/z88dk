
; void zx_scroll(uchar rows, uchar attr)

SECTION seg_code_arch

PUBLIC _zx_scroll

_zx_scroll:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "arch/zx/misc/z80/asm_zx_scroll.asm"
