; unsigned int sms_vdp_feature_enable(unsigned int features)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_vdp_feature_enable_fastcall

EXTERN asm_sms_vdp_feature_enable

defc _sms_vdp_feature_enable_fastcall = asm_sms_vdp_feature_enable
