; void sms_psg_silence(void)

SECTION code_clib
SECTION code_arch

PUBLIC sms_psg_silence

EXTERN asm_sms_psg_silence

defc sms_psg_silence = asm_sms_psg_silence

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sms_psg_silence
defc _sms_psg_silence = sms_psg_silence
ENDIF

