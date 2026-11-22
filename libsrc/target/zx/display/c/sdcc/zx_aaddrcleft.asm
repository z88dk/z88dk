
; void *zx_aaddrcleft(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_aaddrcleft

EXTERN asm_zx_aaddrcleft

_zx_aaddrcleft:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_aaddrcleft
