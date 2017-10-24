; void tshc_scroll_up_attr(uchar prows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_scroll_up_attr

EXTERN asm0_tshc_scroll_up_attr

_tshc_scroll_up_attr:

   pop af
   pop de
   
   push de
   push af
   
   ld l,d
   jp asm0_tshc_scroll_up_attr
