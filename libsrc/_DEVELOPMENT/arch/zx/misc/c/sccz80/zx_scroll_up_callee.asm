
; void zx_scroll_up_callee(uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_scroll_up_callee

EXTERN asm0_zx_scroll_up

zx_scroll_up_callee:

   pop af
   pop hl
   pop de
   push af

   ld d,0
   jp asm0_zx_scroll_up
