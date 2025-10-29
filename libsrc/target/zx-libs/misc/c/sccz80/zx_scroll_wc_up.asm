
; void zx_scroll_wc_up(struct r_Rect8 *r, uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_scroll_wc_up

EXTERN asm0_zx_scroll_wc_up

zx_scroll_wc_up:

   pop af
   pop hl
   pop de
   pop ix
   
   push hl
   push de
   push hl
   push af

   ld d,0
   jp asm0_zx_scroll_wc_up
