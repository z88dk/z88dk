; void tshc_visit_wc_attr(struct r_Rect8 *r, void *function)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_visit_wc_attr_callee

EXTERN asm_tshc_visit_wc_attr

tshc_visit_wc_attr_callee:

   pop af
   pop de
   pop ix
   push af
   
   jp asm_tshc_visit_wc_attr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_visit_wc_attr_callee
defc _tshc_visit_wc_attr_callee = tshc_visit_wc_attr_callee
ENDIF

