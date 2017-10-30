; void tshc_visit_wc_attr(struct r_Rect8 *r, void *function)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_visit_wc_attr

EXTERN asm_tshc_visit_wc_attr

_tshc_visit_wc_attr:

   pop af
   pop ix
   pop de
   
   push de
   push de
   push af
   
   jp asm_tshc_visit_wc_attr
