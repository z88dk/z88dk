
; void zx_border(uchar colour)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_border

EXTERN asm_zx_border

_zx_border:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_border
