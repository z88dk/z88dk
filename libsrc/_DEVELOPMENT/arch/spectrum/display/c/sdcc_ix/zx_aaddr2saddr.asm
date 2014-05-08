
; void *zx_aaddr2saddr(void *attraddr)

PUBLIC _zx_aaddr2saddr

_zx_aaddr2saddr:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_aaddr2saddr.asm"
