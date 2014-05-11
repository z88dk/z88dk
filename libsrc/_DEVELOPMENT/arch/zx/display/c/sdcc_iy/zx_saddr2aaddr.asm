
; void *zx_saddr2aaddr(void *saddr)

PUBLIC _zx_saddr2aaddr

_zx_saddr2aaddr:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_saddr2aaddr.asm"
