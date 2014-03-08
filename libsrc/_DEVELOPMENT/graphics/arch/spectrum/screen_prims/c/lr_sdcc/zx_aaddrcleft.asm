
; void *zx_aaddrcleft(void *attraddr)

XDEF zx_aaddrcleft

zx_aaddrcleft:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_zx_aaddrcleft.asm"
