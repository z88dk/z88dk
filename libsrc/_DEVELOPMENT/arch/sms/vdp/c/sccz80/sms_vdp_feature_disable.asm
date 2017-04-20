; unsigned int sms_vdp_feature_disable(unsigned int features)

SECTION code_clib
SECTION code_arch

PUBLIC sms_vdp_feature_disable

EXTERN asm_sms_vdp_feature_disable

defc sms_vdp_feature_disable = asm_sms_vdp_feature_disable
