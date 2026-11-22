
; void *zx_aaddrcright(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_aaddrcright

EXTERN asm_zx_aaddrcright

_zx_aaddrcright:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_aaddrcright
