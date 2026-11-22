; unsigned int sms_vdp_feature_disable(unsigned int features)

SECTION code_clib
SECTION code_arch

PUBLIC sms_vdp_feature_disable

EXTERN asm_sms_vdp_feature_disable

defc sms_vdp_feature_disable = asm_sms_vdp_feature_disable

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sms_vdp_feature_disable
defc _sms_vdp_feature_disable = sms_vdp_feature_disable
ENDIF

