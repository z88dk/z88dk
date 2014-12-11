
; void zx_scroll_wc_up(struct r_Rect8 *r, uchar rows, uchar attr)

SECTION code_arch

PUBLIC _zx_scroll_wc_up

_zx_scroll_wc_up:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_zx_scroll_wc_up
   
   pop ix
   ret
   
   INCLUDE "arch/zx/misc/z80/asm_zx_scroll_wc_up.asm"
