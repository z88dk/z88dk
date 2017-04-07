; void sms_psg_silence(void)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_sms_psg_silence

asm_sms_psg_silence:

   ; uses : f, bc, hl
   
   ld hl,table_silence
   ld c,__IO_PSG

   ld b,4
   otir

   ret

table_silence:

   defb 0x9f, 0xbf, 0xdf, 0xff
