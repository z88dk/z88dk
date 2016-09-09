SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_set_vram_write_de

asm_sms_set_vram_write_de:

   ; enter : de = vram address
   ;
   ; uses  : af

   ld a,e
   out ($bf),a
   ld a,d
   or $40
   out ($bf),a
   
   ret
