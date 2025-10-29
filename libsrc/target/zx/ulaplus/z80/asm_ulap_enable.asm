; void ulap_enable(void)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_ulap_enable

asm_ulap_enable:

   ; uses : af, bc

   ld bc,__IO_ULAP_REGISTER

   ld a,0x40
   out (c),a

   ld b,__IO_ULAP_DATA / 256
   
   ld a,1
   out (c),a
   
   ret
