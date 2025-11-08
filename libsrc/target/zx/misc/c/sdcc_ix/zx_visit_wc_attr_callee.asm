; void zx_visit_wc_attr(struct r_Rect8 *r, void *function)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_visit_wc_attr_callee

EXTERN asm_zx_visit_wc_attr

_zx_visit_wc_attr_callee:

   pop hl
   pop bc
   ex (sp),hl

l0_zx_visit_wc_attr_callee:

   ex de,hl
   
   push bc
   ex (sp),ix

   call asm_zx_visit_wc_attr

   pop ix
   ret
