; unsigned int sms_vdp_feature_enable(unsigned int features)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_sms_vdp_feature_enable
PUBLIC asm_sms_vdp_feature_enable_0

EXTERN _GLOBAL_SMS_VDP_R0R1

asm_sms_vdp_feature_enable:

   ; enter : hl = R1/R0 bits to enable
   ;
   ; exit  : hl = new R1/R0 contents
   ;
   ; uses  : af, de, hl
   
   ld de,(_GLOBAL_SMS_VDP_R0R1)
   
   ld a,e
   or l
   ld l,a
   
   ld a,d
   or h
   ld h,a

asm_sms_vdp_feature_enable_0:

   di
   
   out (__IO_VDP_COMMAND),a
   
   ld a,$81
   out (__IO_VDP_COMMAND),a
   
   ld a,l
   out (__IO_VDP_COMMAND),a
   
   ld a,$80
   out (__IO_VDP_COMMAND),a
   
   ld (_GLOBAL_SMS_VDP_R0R1),hl
   
   ei
   ret
