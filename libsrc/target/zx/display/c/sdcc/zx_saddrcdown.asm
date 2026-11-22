
; void *zx_saddrcdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddrcdown

EXTERN asm_zx_saddrcdown

_zx_saddrcdown:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_saddrcdown
