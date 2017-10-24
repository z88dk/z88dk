; void tshr_visit_wc_pix(struct r_Rect8 *r, void *function)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_visit_wc_pix

EXTERN l0_tshr_visit_wc_pix_callee

_tshr_visit_wc_pix:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp l0_tshr_visit_wc_pix_callee
