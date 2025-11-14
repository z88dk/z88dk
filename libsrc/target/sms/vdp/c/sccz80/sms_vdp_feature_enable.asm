; unsigned int sms_vdp_feature_enable(unsigned int features)

SECTION code_clib
SECTION code_arch

PUBLIC sms_vdp_feature_enable

EXTERN asm_sms_vdp_feature_enable

defc sms_vdp_feature_enable = asm_sms_vdp_feature_enable

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sms_vdp_feature_enable
defc _sms_vdp_feature_enable = sms_vdp_feature_enable
ENDIF

