
; void zx_scroll_up_callee(uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_scroll_up_callee

EXTERN asm_zx_scroll_up

zx_scroll_up_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_zx_scroll_up
