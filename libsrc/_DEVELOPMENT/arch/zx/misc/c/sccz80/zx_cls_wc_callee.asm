
; void zx_cls_wc(struct r_Rect8 *r, uchar attr)

SECTION code_arch

PUBLIC zx_cls_wc_callee

zx_cls_wc_callee:

   pop af
   pop hl
   pop ix
   push af
   
   INCLUDE "arch/zx/misc/z80/asm_zx_cls_wc.asm"
