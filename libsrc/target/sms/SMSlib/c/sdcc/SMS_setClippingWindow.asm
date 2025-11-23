; void SMS_setClippingWindow(unsigned char x0,unsigned char y0,unsigned char x1,unsigned char y1)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setClippingWindow

EXTERN asm_SMSlib_setClippingWindow

_SMS_setClippingWindow:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp asm_SMSlib_setClippingWindow
