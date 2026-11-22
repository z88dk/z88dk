; void tshc_cls_attr(unsigned char attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cls_attr

EXTERN asm_tshc_cls_attr

_tshc_cls_attr:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_tshc_cls_attr
