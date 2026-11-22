; void SMS_setSpriteMode(unsigned char mode)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setSpriteMode_fastcall

EXTERN asm_SMSlib_setSpriteMode

defc _SMS_setSpriteMode_fastcall = asm_SMSlib_setSpriteMode
