
; void *zx_saddrcup(void *saddr)

SECTION seg_code_arch

PUBLIC _zx_saddrcup

_zx_saddrcup:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "arch/zx/display/z80/asm_zx_saddrcup.asm"
