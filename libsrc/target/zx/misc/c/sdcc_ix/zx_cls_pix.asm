; void zx_cls_pix(uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cls_pix

EXTERN asm_zx_cls_pix

_zx_cls_pix:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_zx_cls_pix
