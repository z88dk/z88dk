; unsigned int sms_vdp_feature_disable(unsigned int features)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_vdp_feature_disable_fastcall

EXTERN asm_sms_vdp_feature_disable

defc _sms_vdp_feature_disable_fastcall = asm_sms_vdp_feature_disable
