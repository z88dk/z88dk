
; void *zx_saddrcright(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddrcright

EXTERN asm_zx_saddrcright

_zx_saddrcright:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_saddrcright
