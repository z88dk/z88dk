
; void *zx_saddrcright(void *saddr)

SECTION seg_code_arch

PUBLIC _zx_saddrcright

_zx_saddrcright:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_saddrcright.asm"
