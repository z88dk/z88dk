; void sms_display_on(void)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_sms_display_on

EXTERN asm_sms_vdp_feature_enable

asm_sms_display_on:

   ; uses : af, de, hl

   ld hl,__VDP_FEATURE_SHOW_DISPLAY
	jp asm_sms_vdp_feature_enable
