; void tshr_cls_pix(uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_cls_pix

EXTERN asm_tshr_cls_pix

_tshr_cls_pix:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_tshr_cls_pix
