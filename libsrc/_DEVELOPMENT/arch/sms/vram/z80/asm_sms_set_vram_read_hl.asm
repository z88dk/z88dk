INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_set_vram_read_hl

asm_sms_set_vram_read_hl:

   ; enter : hl = vram address
   ;
   ; uses  : af

   di

   ld a,l
   out (__IO_VDP_COMMAND),a
   ld a,h
   out (__IO_VDP_COMMAND),a

   ei   
   ret
