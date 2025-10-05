; void SMS_setClippingWindow(unsigned char x0,unsigned char y0,unsigned char x1,unsigned char y1)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_setClippingWindow_callee

EXTERN asm_SMSlib_setClippingWindow

SMS_setClippingWindow_callee:

   pop af
   pop de
   pop hl
   ld h,e
   pop bc
   pop de
   ld d,c
   push af

   jp asm_SMSlib_setClippingWindow
