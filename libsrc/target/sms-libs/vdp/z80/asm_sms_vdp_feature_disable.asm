; unsigned int sms_vdp_feature_disable(unsigned int features)

SECTION code_clib
SECTION code_arch

PUBLIC asm_sms_vdp_feature_disable

EXTERN _GLOBAL_SMS_VDP_R0R1
EXTERN asm_sms_vdp_feature_enable_0

asm_sms_vdp_feature_disable:

   ; enter : hl = R1/R0 bits to disable
   ;
   ; exit  : hl = new R1/R0 contents
   ;
   ; uses  : af, de, hl
   
   ld de,(_GLOBAL_SMS_VDP_R0R1)
   
   ld a,l
   cpl
   and e
   ld l,a
   
   ld a,h
   cpl
   and d
   ld h,a
   
   jp asm_sms_vdp_feature_enable_0
