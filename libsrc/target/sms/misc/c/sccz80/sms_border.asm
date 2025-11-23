; void sms_border(uchar colour)

SECTION code_clib
SECTION code_arch

PUBLIC sms_border

EXTERN asm_sms_border

defc sms_border = asm_sms_border

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sms_border
defc _sms_border = sms_border
ENDIF

