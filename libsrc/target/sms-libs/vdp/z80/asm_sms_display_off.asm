; void sms_display_off(void)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_sms_display_off

EXTERN asm_sms_vdp_feature_disable

asm_sms_display_off:

   ; uses : af, de, hl

   ld hl,__VDP_FEATURE_SHOW_DISPLAY
	jp asm_sms_vdp_feature_disable
