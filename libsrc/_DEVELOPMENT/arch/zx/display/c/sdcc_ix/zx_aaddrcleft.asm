
; void *zx_aaddrcleft(void *attraddr)

SECTION seg_code_arch

PUBLIC _zx_aaddrcleft

_zx_aaddrcleft:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_aaddrcleft.asm"
