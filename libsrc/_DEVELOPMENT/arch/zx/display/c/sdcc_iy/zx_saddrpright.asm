
; void *zx_saddrpright(void *saddr, uint bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddrpright

EXTERN asm_zx_saddrpright

_zx_saddrpright:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_zx_saddrpright
