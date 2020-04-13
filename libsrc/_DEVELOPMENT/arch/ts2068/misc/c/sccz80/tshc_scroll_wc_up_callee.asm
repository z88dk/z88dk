; void tshc_scroll_wc_up(struct r_Rect8 *r, uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_scroll_wc_up_callee

EXTERN asm0_tshc_scroll_wc_up

tshc_scroll_wc_up_callee:

   pop af
   pop hl
   pop de
   pop ix
   push af

   jp asm0_tshc_scroll_wc_up

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_scroll_wc_up_callee
defc _tshc_scroll_wc_up_callee = tshc_scroll_wc_up_callee
ENDIF

