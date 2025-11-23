; void tshc_scroll_wc_up_attr(struct r_Rect8 *r, uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_scroll_wc_up_attr

EXTERN asm0_tshc_scroll_wc_up_attr

tshc_scroll_wc_up_attr:

   pop af
   pop hl
   pop de
   pop ix
   
   push de
   push de
   push hl
   push af

   jp asm0_tshc_scroll_wc_up_attr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_scroll_wc_up_attr
defc _tshc_scroll_wc_up_attr = tshc_scroll_wc_up_attr
ENDIF

