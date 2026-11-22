; void tshr_cls_attr(uchar ink)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_cls_attr

EXTERN asm_tshr_cls_attr

_tshr_cls_attr:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_tshr_cls_attr
