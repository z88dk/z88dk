; void tshc_cls(uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cls

EXTERN asm_tshc_cls

_tshc_cls:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_tshc_cls
