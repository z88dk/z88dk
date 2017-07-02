
; void zx_scroll_up(uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_scroll_up

EXTERN asm0_zx_scroll_up

_zx_scroll_up:

   pop af
   pop de
   
   push de
   push af
   
   ld l,d
   ld d,0
   jp asm0_zx_scroll_up
