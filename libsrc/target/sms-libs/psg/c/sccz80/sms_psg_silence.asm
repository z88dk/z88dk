; void sms_psg_silence(void)

SECTION code_clib
SECTION code_arch

PUBLIC sms_psg_silence

EXTERN asm_sms_psg_silence

defc sms_psg_silence = asm_sms_psg_silence
