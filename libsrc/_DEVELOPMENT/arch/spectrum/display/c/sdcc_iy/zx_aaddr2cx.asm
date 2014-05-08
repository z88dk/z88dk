
; uint zx_aaddr2cx(void *attraddr)

PUBLIC _zx_aaddr2cx

_zx_aaddr2cx:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/spectrum/display/z80/asm_zx_aaddr2cx.asm"
