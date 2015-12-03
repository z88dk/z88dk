
; void zx_scroll_wc_up(struct r_Rect8 *r, uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_scroll_wc_up

EXTERN asm_zx_scroll_wc_up

_zx_scroll_wc_up:

   pop af
   pop ix
   pop de
   pop hl
   
   push hl
   push de
   push hl
   push af
   
   jp asm_zx_scroll_wc_up
