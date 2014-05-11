
; uint zx_saddr2cx(void *saddr)

PUBLIC _zx_saddr2cx

_zx_saddr2cx:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_saddr2cx.asm"
