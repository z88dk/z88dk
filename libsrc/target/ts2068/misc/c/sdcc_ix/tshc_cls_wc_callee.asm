; void tshc_cls_wc(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cls_wc_callee
PUBLIC l0_tshc_cls_wc_callee

EXTERN asm_tshc_cls_wc

_tshc_cls_wc_callee:

   pop hl
   pop de
   dec sp
   ex (sp),hl
   
   ld l,h

l0_tshc_cls_wc_callee:

   push de
   ex (sp),ix

   call asm_tshc_cls_wc

   pop ix
   ret
