; void tshc_visit_wc_pix(struct r_Rect8 *r, void *function)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_visit_wc_pix_callee

EXTERN asm_zx_visit_wc_pix

_tshc_visit_wc_pix_callee:

   pop af
   pop ix
   pop de
   push af
   
   jp asm_zx_visit_wc_pix
