
; void zx_cls_wc(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cls_wc

EXTERN l0_zx_cls_wc_callee

_zx_cls_wc:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af

   jp l0_zx_cls_wc_callee
