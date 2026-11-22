
; void zx_scroll_up(uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_scroll_up

EXTERN asm0_zx_scroll_up

zx_scroll_up:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   ld d,0
   jp asm0_zx_scroll_up
