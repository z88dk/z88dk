; unsigned int sms_vdp_feature_enable(unsigned int features)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_vdp_feature_enable

EXTERN asm_sms_vdp_feature_enable

_sms_vdp_feature_enable:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_sms_vdp_feature_enable
