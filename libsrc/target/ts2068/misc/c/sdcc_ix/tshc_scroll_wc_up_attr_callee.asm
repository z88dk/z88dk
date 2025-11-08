; void tshc_scroll_wc_up_attr(struct r_Rect8 *r, uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_scroll_wc_up_attr_callee
PUBLIC l0_tshc_scroll_wc_up_attr_callee

EXTERN asm0_tshc_scroll_wc_up_attr

_tshc_scroll_wc_up_attr_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   ld e,l
   ld l,h

l0_tshc_scroll_wc_up_attr_callee:

   push bc
   ex (sp),ix
   
   call asm0_tshc_scroll_wc_up_attr
   
   pop ix
   ret
