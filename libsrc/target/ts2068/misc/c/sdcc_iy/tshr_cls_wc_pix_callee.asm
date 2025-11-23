; void tshr_cls_wc_pix(struct r_Rect8 *r, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_cls_wc_pix_callee

EXTERN asm_tshr_cls_wc_pix

_tshr_cls_wc_pix_callee:

   pop hl
   pop ix
   dec sp
   ex (sp),hl
   
   ld l,h
   jp asm_tshr_cls_wc_pix
