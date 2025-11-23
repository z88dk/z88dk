
; void *zx_aaddrcup(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_aaddrcup

EXTERN asm_zx_aaddrcup

_zx_aaddrcup:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_aaddrcup
