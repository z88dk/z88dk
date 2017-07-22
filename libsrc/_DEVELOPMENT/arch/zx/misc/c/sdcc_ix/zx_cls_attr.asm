; void zx_cls_attr(uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cls_attr

EXTERN asm_zx_cls_attr

_zx_cls_attr:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_zx_cls_attr
