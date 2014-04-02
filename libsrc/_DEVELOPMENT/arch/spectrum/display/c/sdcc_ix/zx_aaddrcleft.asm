
; void *zx_aaddrcleft(void *attraddr)

XDEF _zx_aaddrcleft

_zx_aaddrcleft:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_aaddrcleft.asm"
