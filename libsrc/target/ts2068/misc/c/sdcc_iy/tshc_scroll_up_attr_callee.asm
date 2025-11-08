; void tshc_scroll_up_attr(uchar prows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_scroll_up_attr_callee

EXTERN asm0_tshc_scroll_up_attr

_tshc_scroll_up_attr_callee:

   pop hl
   ex (sp),hl
   
   ld e,l
   ld l,h
   jp asm0_tshc_scroll_up_attr
