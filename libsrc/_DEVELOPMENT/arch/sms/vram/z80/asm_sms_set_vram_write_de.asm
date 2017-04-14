INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_set_vram_write_de

asm_sms_set_vram_write_de:

   ; enter : de = vram address
   ;
   ; uses  : af

   di

   ld a,e
   out (__IO_VDP_COMMAND),a
   ld a,d
   or $40
   out (__IO_VDP_COMMAND),a

   ei   
   ret
