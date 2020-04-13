; void tshc_scroll_up_attr(uchar prows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_scroll_up_attr_callee

EXTERN asm0_tshc_scroll_up_attr

tshc_scroll_up_attr_callee:

   pop af
   pop hl
   pop de
   push af

   jp asm0_tshc_scroll_up_attr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_scroll_up_attr_callee
defc _tshc_scroll_up_attr_callee = tshc_scroll_up_attr_callee
ENDIF

