; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_setClippingWindow

EXTERN _clipWin_x0, _clipWin_x1

asm_SMS_setClippingWindow:

   ; void SMS_setClippingWindow (unsigned char x0, unsigned char y0, unsigned char x1, unsigned char y1)
   ;
   ; enter :  l = x0
   ;          h = y0
   ;          e = x1
   ;          d = y1
   ;
   ; uses  : none
   
   ld (_clipWin_x0),hl
   ld (_clipWin_x1),de
   ret
