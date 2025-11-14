; void tshc_visit_wc_attr(struct r_Rect8 *r, void *function)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_visit_wc_attr

EXTERN asm_tshc_visit_wc_attr

tshc_visit_wc_attr:

   pop af
   pop de
   pop ix
   
   push de
   push de
   push af
   
   jp asm_tshc_visit_wc_attr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_visit_wc_attr
defc _tshc_visit_wc_attr = tshc_visit_wc_attr
ENDIF

