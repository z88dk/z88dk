; void tshr_cls_wc_pix(struct r_Rect8 *r, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_cls_pix_callee
PUBLIC l0_tshr_cls_wc_pix_callee

EXTERN asm_tshr_cls_pix

_tshr_cls_pix_callee:

   pop hl
   pop de
   dec sp
   ex (sp),hl
   
   ld l,h
   
l0_tshr_cls_wc_pix_callee:

   push de
   ex (sp),ix
   
   call asm_tshr_cls_pix
   
   pop ix
   ret
