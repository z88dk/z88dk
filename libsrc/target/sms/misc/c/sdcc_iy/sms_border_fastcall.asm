; void sms_border(uchar colour)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_border_fastcall

EXTERN asm_sms_border

defc _sms_border_fastcall = asm_sms_border
