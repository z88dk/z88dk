
; void zx_cls_wc(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cls_wc

EXTERN asm_zx_cls_wc

zx_cls_wc:

   pop af
   pop hl
   pop ix
   
   push hl
   push hl
   push af
   
   jp asm_zx_cls_wc
