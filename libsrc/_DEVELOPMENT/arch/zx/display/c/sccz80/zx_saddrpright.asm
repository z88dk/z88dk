
; void *zx_saddrpright(void *saddr, uint bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddrpright

EXTERN asm_zx_saddrpright

zx_saddrpright:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_zx_saddrpright
