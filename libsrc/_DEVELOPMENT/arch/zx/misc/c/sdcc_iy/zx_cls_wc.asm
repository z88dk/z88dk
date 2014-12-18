
; void zx_cls_wc(struct r_Rect8 *r, uchar attr)

SECTION code_arch

PUBLIC _zx_cls_wc

_zx_cls_wc:

   pop af
   pop ix
   pop hl
   
   push hl
   push ix
   push af
   
   INCLUDE "arch/zx/misc/z80/asm_zx_cls_wc.asm"
