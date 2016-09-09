SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_set_vram_read_hl

asm_sms_set_vram_read_hl:

   ; enter : hl = vram address
   ;
   ; uses  : af

   ld a,l
   out ($bf),a
   ld a,h
   out ($bf),a
   
   ret
