; void SMS_setClippingWindow(unsigned char x0,unsigned char y0,unsigned char x1,unsigned char y1)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setClippingWindow_callee

EXTERN asm_SMSlib_setClippingWindow

_SMS_setClippingWindow_callee:

   pop hl
	pop de
	ex (sp),hl

   jp asm_SMSlib_setClippingWindow
