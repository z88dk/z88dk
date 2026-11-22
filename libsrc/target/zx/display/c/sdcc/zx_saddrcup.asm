
; void *zx_saddrcup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddrcup

EXTERN asm_zx_saddrcup

_zx_saddrcup:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_saddrcup
