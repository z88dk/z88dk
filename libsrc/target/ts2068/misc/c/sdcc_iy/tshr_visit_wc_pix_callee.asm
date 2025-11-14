; void tshr_visit_wc_pix(struct r_Rect8 *r, void *function)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_visit_wc_pix_callee

EXTERN asm_tshr_visit_wc_pix

_tshr_visit_wc_pix_callee:

   pop af
   pop ix
   pop de
   push af
   
   jp asm_tshr_visit_wc_pix
