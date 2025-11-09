
; void *zx_saddrpdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddrpdown

EXTERN asm_zx_saddrpdown

_zx_saddrpdown:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_saddrpdown
