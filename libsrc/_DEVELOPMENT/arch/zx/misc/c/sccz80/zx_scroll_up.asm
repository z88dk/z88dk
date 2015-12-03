
; void zx_scroll_up(uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_scroll_up

EXTERN asm_zx_scroll_up

zx_scroll_up:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_zx_scroll_up
