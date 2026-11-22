
; void zx_cls_wc(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cls_wc_callee

EXTERN asm_zx_cls_wc

zx_cls_wc_callee:

   pop af
   pop hl
   pop ix
   push af
   
   jp asm_zx_cls_wc
