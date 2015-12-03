
; void zx_scroll_up(uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_scroll_up

EXTERN asm_zx_scroll_up

_zx_scroll_up:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_zx_scroll_up
