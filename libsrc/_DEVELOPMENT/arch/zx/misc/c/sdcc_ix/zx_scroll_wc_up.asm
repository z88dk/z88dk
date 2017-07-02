
; void zx_scroll_wc_up(struct r_Rect8 *r, uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_scroll_wc_up

EXTERN l0_zx_scroll_wc_up_callee

_zx_scroll_wc_up:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af

   jp l0_zx_scroll_wc_up_callee
