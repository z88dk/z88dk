; unsigned int sms_vdp_feature_disable(unsigned int features)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_vdp_feature_disable

EXTERN asm_sms_vdp_feature_disable

_sms_vdp_feature_disable:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_sms_vdp_feature_disable
