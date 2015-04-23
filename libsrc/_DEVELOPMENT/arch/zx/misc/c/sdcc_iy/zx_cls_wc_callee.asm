
; void zx_cls_wc_callee(struct r_Rect8 *r, uchar attr)

SECTION code_arch

PUBLIC _zx_cls_wc_callee

_zx_cls_wc_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   INCLUDE "arch/zx/misc/z80/asm_zx_cls_wc.asm"
