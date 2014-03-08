
; void *zx_saddrcup(void *saddr)

XDEF zx_saddrcup

zx_saddrcup:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_zx_saddrcup.asm"
