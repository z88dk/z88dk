; void tshc_visit_wc_attr(struct r_Rect8 *r, void *function)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_visit_wc_attr

EXTERN l0_tshc_visit_wc_attr_callee

_tshc_visit_wc_attr:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp l0_tshc_visit_wc_attr_callee
