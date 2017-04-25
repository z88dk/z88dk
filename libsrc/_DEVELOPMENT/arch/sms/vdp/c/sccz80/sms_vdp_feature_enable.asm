; unsigned int sms_vdp_feature_enable(unsigned int features)

SECTION code_clib
SECTION code_arch

PUBLIC sms_vdp_feature_enable

EXTERN asm_sms_vdp_feature_enable

defc sms_vdp_feature_enable = asm_sms_vdp_feature_enable
