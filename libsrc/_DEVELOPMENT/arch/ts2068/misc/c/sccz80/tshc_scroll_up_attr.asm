; void tshc_scroll_up_attr(uchar prows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_scroll_up_attr

EXTERN asm0_tshc_scroll_up_attr

tshc_scroll_up_attr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp asm0_tshc_scroll_up_attr
