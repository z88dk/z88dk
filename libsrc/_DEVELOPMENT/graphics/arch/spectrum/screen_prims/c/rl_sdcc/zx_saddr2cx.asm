
; uint zx_saddr2cx(void *saddr)

XDEF zx_saddr2cx

zx_saddr2cx:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_zx_saddr2cx.asm"
