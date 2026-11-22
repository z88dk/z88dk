; void ulap_disable(void)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_ulap_disable

asm_ulap_disable:

   ; uses : af, bc

   ld bc,__IO_ULAP_REGISTER

   ld a,0x40
   out (c),a

   ld b,__IO_ULAP_DATA / 256
   
   xor a
   out (c),a
   
   ret
