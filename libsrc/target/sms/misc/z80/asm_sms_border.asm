; ===============================================================
; 2017
; ===============================================================
; 
; void sms_border(uchar colour)
;
; Set border colour.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_sms_border

asm_sms_border:

   ; enter :  l = border colour 0..7
   ;
   ; uses  : af
   
   ld a,l
   
   and $0f
   or $f0
   
   di
   
   out (__IO_VDP_COMMAND),a
   
   ld a,$87
   out (__IO_VDP_COMMAND),a
   
   ei
   ret
