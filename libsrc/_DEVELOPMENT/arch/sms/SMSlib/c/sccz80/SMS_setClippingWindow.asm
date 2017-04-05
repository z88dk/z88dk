; void SMS_setClippingWindow(unsigned char x0,unsigned char y0,unsigned char x1,unsigned char y1)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_setClippingWindow

EXTERN asm_SMSlib_setClippingWindow

SMS_setClippingWindow:

   pop af
   pop bc
   pop hl
   pop ix
   pop de
   
   push de
   push de
   push hl
   push bc
   push af
   
   ld h,c
   ld d,ixl
   jp asm_SMSlib_setClippingWindow
