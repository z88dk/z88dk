; void zx_visit_wc_pix(struct r_Rect8 *r, void *function)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_visit_wc_pix_callee

EXTERN asm_zx_visit_wc_pix

_zx_visit_wc_pix_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   ex de,hl
   jp asm_zx_visit_wc_pix
