
; void *zx_saddrcleft(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddrcleft

EXTERN asm_zx_saddrcleft

_zx_saddrcleft:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_saddrcleft
