; void sms_psg_silence(void)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_sms_psg_silence
EXTERN asm_PSGlib_SilenceChannels

defc asm_sms_psg_silence = asm_PSGlib_SilenceChannels
