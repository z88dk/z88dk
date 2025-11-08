
; void zx_cls(uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cls

EXTERN asm_zx_cls

_zx_cls:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_zx_cls
