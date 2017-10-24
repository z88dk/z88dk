; void tshr_visit_wc_pix(struct r_Rect8 *r, void *function)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_visit_wc_pix_callee
PUBLIC l0_tshr_visit_wc_pix_callee

EXTERN asm_tshr_visit_wc_pix

_tshr_visit_wc_pix_callee:

   pop af
   pop bc
   pop de
   push af

l0_tshr_visit_wc_pix_callee:

   push bc
   ex (sp),ix
   
   call asm_tshr_visit_wc_pix

   pop ix
   ret
