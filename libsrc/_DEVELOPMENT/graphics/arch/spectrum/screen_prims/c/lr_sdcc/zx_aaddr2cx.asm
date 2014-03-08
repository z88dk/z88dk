
; uint zx_aaddr2cx(void *attraddr)

XDEF zx_aaddr2cx

zx_aaddr2cx:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_zx_aaddr2cx.asm"
