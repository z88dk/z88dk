; void tshc_cls_pix(unsigned char pix)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cls_pix

EXTERN asm_tshc_cls_pix

_tshc_cls_pix:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_tshc_cls_pix
