
; void *zx_saddrpup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddrpup

EXTERN asm_zx_saddrpup

_zx_saddrpup:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_saddrpup
