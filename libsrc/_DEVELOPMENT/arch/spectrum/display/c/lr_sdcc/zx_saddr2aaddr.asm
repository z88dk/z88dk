
; void *zx_saddr2aaddr(void *saddr)

XDEF zx_saddr2aaddr

zx_saddr2aaddr:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_zx_saddr2aaddr.asm"
